class RestaurantsController < ApplicationController
  before_filter :set_cache_header

  def restaurants
    @restaurants = Restaurant.all(sort: [[ :name, :asc ]])
    render json: @restaurants, :only => [:name]
  end

  def index
    restaurant = params[:restaurant] || "Mensa"
    @restaurant = Restaurant.where(name: restaurant).first
    @restaurants = Restaurant.all(sort: [[ :name, :desc ]])
  
    if params[:date]
      @today = Date.parse(params[:date]) 
    else
      @today = Date.today
      @today = @today.next if Time.now.hour >= 20
    end
    
    unless @restaurant.menus.where(:date.gt => @today).first
      RestaurantHelper::update_database
      @restaurant.reload
    end

    @menus = @restaurant.menus.where(date: @today.to_time.midnight).where(name: "Mittagessen").to_a + @restaurant.menus.where(date: @today.to_time.midnight).where(name: "Abendessen").to_a
    
    unless @menus.any?
      @today = Date.commercial(Date.today.year, 1+Date.today.cweek, 1)
      @menus = @restaurant.menus.where(date: @today.to_time.midnight).where(name: "Mittagessen").to_a + @restaurant.menus.where(date: @today.to_time.midnight).where(name: "Abendessen").to_a
    end
    
    respond_to do |format|
      format.html {
        @today_js = @today.to_time.utc.to_i*1000
      }
      format.xml
      format.json
    end
  end
end
