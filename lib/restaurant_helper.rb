class RestaurantHelper
  def self.update_database
    old_locale = I18n.locale
    I18n.locale = :de
    
    Restaurant.all.each do |restaurant|
      restaurant.menus.where(:date.lt => Date.today.to_time.midnight.utc).destroy_all
    end
    self.get_menu_data(ENV["STWPB_CSV_URL"]).each do |restaurant, menus|
      current_restaurant = Restaurant.where(api_name: restaurant).first
      unless current_restaurant
        Rails.logger.debug "skipping #{restaurant}"
        next
      end
      menus.each do |menu|
        unless current_restaurant.menus.where(date: menu["date"].to_time.midnight).where(description: menu["description_translations"]["de"]).any?
          current_restaurant.menus.create!(menu)
        end
      end
    end
    
    I18n.locale = old_locale
  end

  
  #protected
  def self.get_menu_data(csv_uri)
    csv = Rails.cache.fetch("iUPB.restaurant_csv", :expires_in => 2.hours) do
      open(csv_uri).read
    end
    csv = self.convert_to_utf8(csv)
    
    menu_data = {}
    counter = 0
    
    rows = CSV.parse(csv, col_sep: ";", skip_blanks: true).drop(1)
    # "NUMMER_VERBRAUCHSORT";"NAME_VERBRAUCHSORT";"DATUM";"ART_DER_SPEISE";"BUTTON";"ABEND";"TEXT_DEUTSCH";"TEXT_ENGLISCH";"ZUSATZSTOFFE";"GAESTE";"STUDIERENDE";"BEDIENSTETE";"TARA"
    rows.each do |row|
      restaurant = row[1]
      Rails.logger.debug "skipping nil restaurant #{row[0]}" and next if restaurant.nil?
      if restaurant.strip == "Mensa Hamm" || (current_restaurant = Restaurant.where(api_name: restaurant.strip).first).nil?
        Rails.logger.debug "skipping not found restaurant #{restaurant}"
        next
      end
      datum = row[2]
      art = row[3]
      buttons = row[4].strip.split(",").map(&:strip).reject(&:blank?)
      abend = (row[5].strip == "a")
      german_desc = row[6]
      english_desc = row[7]
      additives = row[8].split(",").map(&:strip)
      per100g = (row[12].strip == "Tara")
      preisfaktor = (per100g ? 0.1 : 1.0)
      einheit = (per100g ? "pro 100g: " : "")
      guests_price = row[9].sub(",", ".").to_f * preisfaktor
      stud_price = row[10].sub(",", ".").to_f * preisfaktor
      staff_price = row[11].sub(",", ".").to_f * preisfaktor
      order_info = self.order_info(art)
            
      if german_desc.blank?
        Rails.logger.debug "skipping empty German description"
        next
      end
      
      begin # try to parse the date
        parsed_date = DateTime::strptime(datum, "%d.%m.%Y").to_date
      rescue
        parsed_date = DateTime::strptime(datum, "%d.%-m.%Y").to_date
      end
      
      ## following line returns empty array so we do not load menus multiple times if we already have the data
      # return {} if current_restaurant.menus.where(date: parsed_date.to_time.midnight).first
      
      menu_data[restaurant.strip] ||= []
      data = {}
      data["type"] = art.sub(/\d+,\d\d.*/, "").sub("PUB", "").sub("Stamm HK", "").sub("Stamm", "").strip.sub(/ f\z/i, "").sub(/ \d\z/i, "").sub(/ Mensa\z/i, "")
      data["date"] = parsed_date
      data["name_translations"] = (abend ? {"de" => "Abendessen", "en" => "Dinner"} : {"de" => "Mittagessen", "en" => "Lunch"})
      data["dinner"] = abend
      data["description_translations"] = {"de" => german_desc.strip.sub(/\Aund/i, "").strip, "en" => english_desc.strip}
      data["price"] = "#{einheit}Stud. #{('%.02f' % stud_price).sub(".", ",")} / Bed. #{('%.02f' % staff_price).sub(".", ",")} / Gast #{('%.02f' % guests_price).sub(".", ",")}"
      data["counter"] = nil
      data["side_dishes"] = nil
      data["order_info"] = order_info unless order_info.nil?
      data["badges"] = buttons.map do |button|
        case button.try(:strip)
          when "1"
            {"de" => "kalorienarm", "en" => "low-calorie"}
          when "2"
            {"de" => "fettfrei", "en" => "fat-free"}
          when "3"
            {"de" => "vegetarisch", "en" => "vegetarian"}
          when "4"
            {"de" => "vegan", "en" => "vegan"}
          when "5"
            {"de" => "laktosefrei", "en" => "lactose-free"}
          when "6"
            {"de" => "glutenfrei", "en" => "gluten free"}
          else
            nil
          end
        end
      
      data["allergens"] = additives
          
      menu_data[restaurant.strip] << data
      counter += 1
    end

    Rails.logger.debug "returning #{counter} menus"
    menu_data
  end
  
  def self.order_info(art) # Menu.constants(false).select do |c| c.to_s.match(/\ASORT_/) end
    if art.match(/Beilage Waage/i) or art.match(/Beilage klein/i) or art.match(/Beilagensalat/i) or art.match(/Gem?sebeil/i) or art.match(/ttigungsbeil/i)
      Menu::SORT_SALAD
    elsif art.match(/Aktionsdessert/i)
      Menu::SORT_DESSERT_EXPENSIVE
    elsif art.match(/Dessert/i)
      Menu::SORT_DESSERT
    elsif art.match(/Aktionsessen/i)
      Menu::SORT_DISH_EXPENSIVE
    elsif art.match(/Grill Fisch/i)
      Menu::SORT_GRILL
    elsif art.match(/Pasta/i)
      Menu::SORT_BUFFET
    elsif art.match(/Fladenbrot/i) or art.match(/Mittags-Angebot/i) or art.match(/Essen \d/)
      Menu::SORT_MAIN_DISHES
    elsif art.match(/Stamm HK/i) or art.match(/Hauptkompononte/i)
      Menu::SORT_HK
    elsif art.match(/Stamm Waage/i) or art.match(/WOK-Buffet/i)
      Menu::SORT_BUFFET
    elsif art.match(/Eintopf/i)
      Menu::SORT_SOUP
    elsif art.match(/Tagessuppe/i)
      Menu::SORT_SMALL_SOUP
    end
  end
  
  def self.convert_to_utf8(new_value)
    begin
      # Try it as UTF-8 directly
      cleaned = new_value.dup.force_encoding('UTF-8')
      unless cleaned.valid_encoding?
        # Some of it might be old Windows code page
        cleaned = new_value.encode( 'UTF-8', 'Windows-1252' )
      end
      new_value = cleaned
    rescue EncodingError
      # Force it to UTF-8, throwing out invalid bits
      new_value.encode!( 'UTF-8', invalid: :replace, undef: :replace )
    end
  end
  
end
