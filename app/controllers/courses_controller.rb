class CoursesController < ApplicationController
  def index
    #@networks = Network.all
  end
  
  def show
    @course = Course.find(params[:id])
    
    # If the request is stale according to the given timestamp and etag value
    # (i.e. it needs to be processed again) then execute this block
    #if stale?(:last_modified => Time.now - 7.days, :etag => @course)
    #  expires_in 7.days, :public => true, 'max-stale' => 0
    #end
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
    @courses = []
    @courses = Course.where(course_type: 'course').where(title_downcase: /.*#{query}.*/).limit(10).entries if query.length > 2
    
    @courses.each do |course|
      min_interval = 100.days
      course.course_data.each do |data|
        next_class = data['date'].to_date
        interval = next_class - Date.today
        if next_class >= Date.today and interval < min_interval
          course['next_class'] = {
            date: next_class,
            room: data['room'],
            time_from: data['time_from'],
            time_to: data['time_to']
            #instructor: data['instructor']
          }
          min_interval = interval
        end
      end
    end  
    # If the request is stale according to the given timestamp and etag value
    # (i.e. it needs to be processed again) then execute this block
    #if stale?(:last_modified => Time.now + 7.days, :etag => @courses)
    #  expires_in 7.days, :public => true, 'max-stale' => 0
    #end
  end
end
