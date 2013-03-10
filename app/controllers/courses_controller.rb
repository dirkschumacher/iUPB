class CoursesController < ApplicationController
  def index
  end
  
  def show
    begin
      @course = Course.find(params[:id])
      @course.update_next_class_information!
      @groups = load_groups @course
      respond_to do |format|
        format.html
        format.json
      end
    rescue ::Mongoid::Errors::DocumentNotFound
      respond_to do |format|
        format.html { render 'gone', :status => :gone }
        format.json { head :not_found }
      end
    end
  end
 
  def search
    query = params[:query].downcase
    @courses = []
    if query.length > 2
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
      update_next_class_information @courses
    end
    set_cache_header(60*60) # only cache 1 hour
  end
  
  private
  
  def update_next_class_information(courses)
    courses.each do |course|
      course.update_next_class_information!
    end
  end
  
  def load_groups(course) 
    if @course.course_type == 'course'
      groups = Course.where(paul_id: @course.paul_id)
                      .where(course_type: 'group')
                      .excludes(id: @course.id)
                      .order_by([[:title_downcase, :asc]])
                      .entries
      update_next_class_information groups
      groups
    else
      []
    end
  end
end
