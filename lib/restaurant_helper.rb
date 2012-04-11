class RestaurantHelper
  def self.update_database
    Restaurant.all.each do |restaurant|
      restaurant.menus.where(:date.lt => Date.today.to_time.midnight.utc).destroy_all
      get_menu_data(restaurant).each do |menu|
        restaurant.menus.create!(menu)
      end
    end
  end
  
  #updates translations of a menu if no translation is available for the specific locale
  def self.update_translations(menu, from_locale, to_locale)
    unless menu.respond_to?(:name)
      raise "Supplied menu does not have a name property"
    end
    if menu.name_translations[from_locale] and not menu.name_translations[to_locale]  
      menu_name = translator.translate menu.name_translations[from_locale], :from => from_locale, :to => to_locale
      menu.name_translations = menu.name_translations.merge({to_locale => menu_name})
      menu.save
    end    
  end
  
  protected
  def self.get_menu_data(restaurant)
    if restaurant.is_a?(String)
      restaurant = Restaurant.where(name: restaurant).first
    end
    unless restaurant.respond_to?(:feed_url)
      raise "Supplied restaurant does not exist"
    end
    url = restaurant.feed_url
    xml = open(url).read
    menu = Nokogiri.XML(xml)
    menus = []
    
    menu.xpath("//tag").each do |tag|
      datum = tag.search("datum").first.text
      tag.search("menue").each do |current_menu|
        data = {}
        data["name"] = current_menu.search("menu").first.text
        data["date"] = DateTime::strptime(datum, "%d.%m.%Y").to_date
        data["type"] = current_menu.search("speisentyp").first.text unless current_menu.search("speisentyp")
        data["description"] = current_menu.search("text").first.text unless current_menu.search("text")
        data["price"] = current_menu.search("preis").first.text unless current_menu.search("preis")
        data["counter"] = current_menu.search("ausgabe").first.text unless current_menu.search("ausgabe")
        data["side_dishes"] = current_menu.search("beilage").map do |beilage| beilage.text  end
        menus << data
      end
    end
    menus
  end
  
end