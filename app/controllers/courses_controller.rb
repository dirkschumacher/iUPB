class CoursesController < ApplicationController
  # before_filter :set_cache_header, :except => :search

  def index
  end
  
  def show
    begin
      @course = Course.find(params[:id])
      update_course @course
      if @course.course_type == 'course'
        @groups = Course.where(paul_id: @course.paul_id).where(course_type: 'group').excludes(id: @course.id).order_by([[:title_downcase, :asc]]).entries
        update_courses @groups
      end
    rescue ::Mongoid::Errors::DocumentNotFound
      render 'gone', :status => :gone
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
    if query.length > 2
      #title_downcase: /.*#{query}.*/, 
      db_query = Course.where(course_type: 'course')
      search_condition = []
      query.split(" ").each do |word| 
        word = word.strip
        search_condition << {'$or' => [ 
          {meta_lecturer_names: /.*#{word}.*/}, 
          {meta_rooms: /.*#{word}.*/} , 
          {course_short_desc_downcase: /.*#{word}.*/} ,
          {title_downcase: /.*#{word}.*/}
        ]}
      end
      @courses = db_query.where('$and' => search_condition).limit(10).entries
      update_courses @courses
    end
    set_cache_header(60*60) # only cache 1 hour
  end
  def update_course(course)
    min_interval = 100.days
    course.course_data.each do |data|
      time_from = Time.new(data["date"].year, data["date"].month, data["date"].day, data["time_from"].to_time.hour, data["time_from"].to_time.min).utc
      time_to = Time.new(data["date"].year, data["date"].month, data["date"].day, data["time_to"].to_time.hour, data["time_to"].to_time.min).utc
      data['time_from'] = time_from
      data['time_to'] = time_to
      interval = time_to - Time.now
      if time_to >= Time.now and interval < min_interval
        course.next_class = {
          room: data['room'].length == 0 ? t('courses.room_na') : data['room'],
          time_from: time_from,
          time_to: time_to
          #instructor: data['instructor']
        }
        min_interval = interval
      end
    end
  end
  def update_courses(courses)
    courses.each do |course|
      update_course course
    end
  end
end
