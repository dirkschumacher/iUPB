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
    @menus.each do |menu|
      RestaurantHelper::update_translations(menu, "de", "en")
      RestaurantHelper::update_translations(menu, "de", "es")
      RestaurantHelper::update_translations(menu, "de", "fr")
    end
  end
end
