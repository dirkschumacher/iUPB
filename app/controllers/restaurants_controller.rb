class RestaurantsController < ApplicationController
  def index
    restaurant = "Mensa"
    @restaurant = Restaurant.where(name: restaurant).first
  
    @today = Date.today
        
    unless @restaurant.menus.where(:date.gt => @today).first
      RestaurantHelper::update_database
      @restaurant.reload
    end

    @menus = @restaurant.menus.where(date: @today.to_time.midnight.utc )
      
    unless @menus.any?
      @today = Date.commercial(Date.today.year, 1+Date.today.cweek, 1)
      @menus = @restaurant.menus.where(date: @today.to_time.midnight.utc)
    end
    
  end
  
  protected
  def get_menu_data(restaurant = :mensa)
    url = "http://www.studentenwerk-pb.de/fileadmin/xml/#{restaurant.to_s}.xml"
    # naive approach, not for production
    xml = Rails.cache.fetch("menu_#{restaurant.to_s}_xml_data", :expires_in => 6.days) do
      open(url).read
    end
    menu = Nokogiri.XML(xml)
    menu_hash = {}
    
    menu.xpath("//tag").each do |tag|
      datum = tag.search("datum").first.text
      menu_hash[datum] = {}
      menu_hash[datum]["wochentag"] = tag.search("wochentag").first.text
      menu_hash[datum]["menus"] = []
      tag.search("menue").each do |current_menu|
        data = {}
        data["name"] = current_menu.search("menu").first.text
        data["typ"] = ""
        data["typ"] = current_menu.search("speisentyp").first.text if current_menu.search("speisentyp").first
        data["text"] = current_menu.search("text").first.text unless current_menu.search("text")
        data["beilage"] = current_menu.search("beilage").map do |beilage| beilage.text  end
        menu_hash[datum]["menus"] << data
      end
    end
    menu_hash
  end
end
