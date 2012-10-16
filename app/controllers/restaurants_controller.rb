class RestaurantsController < ApplicationController
  before_filter :set_cache_header

  def restaurants
    @restaurants = Restaurant.all(sort: [[ :name, :asc ]])
    render json: @restaurants, :only => [:name]
  end

  def index
    restaurant = params[:restaurant]||"Mensa"
    @restaurant = Restaurant.where(name: restaurant).first
    @restaurants = Restaurant.all(sort: [[ :name, :asc ]])
  
    if params[:date]
      @today = Date.parse(params[:date]) 
    else
      @today = Date.today
      @today = @today.next if Time.now.hours >= 20
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
