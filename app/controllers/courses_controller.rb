class CoursesController < ApplicationController
  def index
    #@networks = Network.all
  end
  
  def show
  end

  def new
  end

  def edit
  end

  def update
  end

  def create
  end

  def destroy
  end
  
  def search
    query = params[:query].downcase
    @courses = Course.where(title_downcase: /.*#{query}.*/).limit(10).all
    # If the request is stale according to the given timestamp and etag value
    # (i.e. it needs to be processed again) then execute this block
    if stale?(:last_modified => Time.now - 7.days, :etag => @courses)
      render "search"
    end
  end
end
