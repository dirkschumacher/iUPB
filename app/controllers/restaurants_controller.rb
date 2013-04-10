class RestaurantsController < ApplicationController
  before_filter :set_cache_header
  @@mutex = Mutex.new

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
      if @@mutex.try_lock # am I the first to request new data?
        RestaurantHelper::update_database # then download and parse
        @@mutex.unlock # and finish locking
      else # if already somebody else is loading new data
        @@mutex.lock; @@mutex.unlock # just wait until it's done
      end
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
  end
end
