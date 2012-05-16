class CoursesController < ApplicationController
  before_filter :set_cache_header, :except => :search

  def index
  end
  
  def show
    @course = Course.find(params[:id])
    if @course.course_type == 'course'
      @groups = Course.where(paul_id: @course.paul_id).where(course_type: 'group').excludes(id: @course.id).order_by([[:title_downcase, :asc]]).entries
      attach_next_class @groups
    end
    # If the request is stale according to the given timestamp and etag value
    # (i.e. it needs to be processed again) then execute this block
    #if stale?(:last_modified => Time.now - 7.days, :etag => @course)
    #  expires_in 7.days, :public => true, 'max-stale' => 0
    #end
  end
 
  def search
    query = params[:query].downcase
    @courses = []
    @courses = Course.where(course_type: 'course').where(title_downcase: /.*#{query}.*/).limit(10).entries if query.length > 2
    
    attach_next_class @courses
    set_cache_header(60*60) # only cache 1 hour
  end
  def attach_next_class(courses)
    courses.each do |course|
      min_interval = 100.days
      course.course_data.each do |data|
        next_class = data['date'].to_date
        interval = next_class - Date.today
        if next_class >= DateTime.now and interval < min_interval
          course['next_class'] = {
            date: next_class,
            room: data['room'].length == 0 ? t('courses.room_na') : data['room'],
            time_from: data['time_from'],
            time_to: data['time_to']
            #instructor: data['instructor']
          }
          min_interval = interval
        end
      end
    end
  end
end
