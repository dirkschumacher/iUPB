class RestaurantsController < ApplicationController
  def index
    @restaurant = params[:restaurant]||"mensa"
    menu = get_menu_data(@restaurant)
    today = Date.today
    today = Date.commercial(Date.today.year, 1+Date.today.cweek, 1) unless menu[today.strftime("%d.%m.%Y")]
    @menu = menu[today.strftime("%d.%m.%Y")]
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
