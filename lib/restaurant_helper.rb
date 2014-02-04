class RestaurantHelper
  def self.update_database
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
        unless current_restaurant.menus.where(date: menu["date"].to_time.midnight).where(description: menu["description"]).any?
          current_restaurant.menus.create!(menu)
        end
      end
    end
  end

  
  #protected
  def self.get_menu_data(csv_uri)
    old_locale = I18n.locale
    I18n.locale = :de
    
    csv = Rails.cache.fetch("iUPB.restaurant_csv", :expires_in => 2.hours) do
      open(csv_uri).read
    end
    csv = self.convert_to_utf8(csv)
    
    menu_data = {}
    counter = 0
    
    rows = CSV.parse(csv, col_sep: ";").drop(1)
    # "NUMMER_VERBRAUCHSORT";"NAME_VERBRAUCHSORT";"DATUM";"ART_DER_SPEISE";"BUTTON";"ABEND";"TEXT_DEUTSCH";"TEXT_ENGLISCH";"ZUSATZSTOFFE";"GAESTE";"STUDIERENDE";"BEDIENSTETE";"TARA"
    rows.each do |row|
      restaurant = row[1]
      if restaurant.strip == "Mensa Hamm" || (current_restaurant = Restaurant.where(api_name: restaurant.strip).first).nil?
        Rails.logger.debug "skipping not found restaurant #{restaurant}"
        next
      end
      datum = row[2]
      art = row[3]
      button = row[4].strip
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
      data["type"] = art.sub(/\d+,\d\d.*/, "").sub("PUB", "").sub("Stamm HK", "").sub("Stamm", "").strip.sub(/f \z/i, "")
      data["date"] = parsed_date
      data["name"] = (abend ? "Abendessen" : "Mittagessen")
      data["description"] = german_desc.strip.sub(/\Aund/i, "").strip
      data["price"] = "#{einheit}Stud. #{('%.02f' % stud_price).sub(".", ",")} / Bed. #{('%.02f' % staff_price).sub(".", ",")} / Gast #{('%.02f' % guests_price).sub(".", ",")}"
      data["counter"] = nil
      data["side_dishes"] = nil
      data["badge"] = case button
        when "1"
          "kalorienarm"
        when "2"
          "fettfrei"
        when "3"
          "vegetarisch"
        when "4"
          "vegan"
        when "5"
          "lactosefrei"
        when "6"
          "glutenfrei"
        else
          nil
        end
          
      menu_data[restaurant.strip] << data
      counter += 1
    end
    
    I18n.locale = old_locale
    Rails.logger.debug "returning #{counter} menus"
    menu_data
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
