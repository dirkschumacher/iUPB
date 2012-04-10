class RestaurantHelper
  def update_database
    Restaurant.all.each do |restaurant|
      restaurant.menus.all(:date.lt => Date.now).destroy_all
      get_menu_data(restaurant).each do |menu|
        restaurant.menus.create!(menu)
      end
    end
  end
  def get_menu_data(restaurant)
    if restaurant.is_a(String)
      restaurant = Restaurant.where(name: restaurant).first
    end
    unless restaurant.responds_to?(:feed_url)
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