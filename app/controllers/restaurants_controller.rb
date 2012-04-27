class RestaurantsController < ApplicationController
  def index
    restaurant = "Mensa"
    @restaurant = Restaurant.where(name: restaurant).first
  
    if params[:date]
      @today = Date.parse(params[:date]) 
    else
      @today = Date.today
    end
    unless @restaurant.menus.where(:date.gt => @today).first
      RestaurantHelper::update_database
      @restaurant.reload
    end

    @menus = @restaurant.menus.where(date: @today.to_time.midnight )
      
    unless @menus.any?
      @today = Date.commercial(Date.today.year, 1+Date.today.cweek, 1)
      @menus = @restaurant.menus.where(date: @today.to_time.midnight)
    end
    
    respond_to do |format|
      format.html {
        @today_js = @today.to_time.utc.to_i*1000
      }
      format.xml
      format.json
    end

    #@menus.each do |menu|
    #  RestaurantHelper::update_translations(menu, "de", "en")
    #  RestaurantHelper::update_translations(menu, "de", "es")
    #  RestaurantHelper::update_translations(menu, "de", "fr")
    #end
  end
end
