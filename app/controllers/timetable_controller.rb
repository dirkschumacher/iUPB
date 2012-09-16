class TimetableController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @event = current_user.events.build
  end
  
  def add_course
    head :precondition_failed and return unless params[:id]
    course = Course.find(params[:id])
    dates = course.get_dates(true)
    unless course_present?(course, current_user)
      dates.each do |date|
        event = current_user.events.build
        event.start_time = date[0]
        event.end_time = date[1]
        event.name = course.title
        event.description = date[3]
        event.location = date[2]
        event.course = course
        event.save!
      end
    end
    head :ok
  end

  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      redirect_to timetable_path, notice: "Alright... Saved that! :)"
    else
      render "new"
    end
  end

  def destroy
    event = current_user.events.find(params[:id])
    event.delete
    head :ok
  end

  def index
    if params[:year] and params[:week]
      @start_time = Date.commercial(params[:year].to_i, params[:week].to_i).to_time.beginning_of_week
      @end_time = @start_time.end_of_week - 2.days
    else
      if Time.now > Time.now.end_of_week - 2.days # weekend
        @start_time = (Time.now.end_of_week + 1.days).beginning_of_week
        @end_time = @start_time.end_of_week - 2.days
      else
        @start_time = Time.now.beginning_of_week
        @end_time = Time.now.end_of_week - 2.days
      end
    end  
    @events = current_user.events.where(start_time: @start_time..@end_time).asc(:start_time)
    @userHasNoCourses = current_user.events.length == 0
    respond_to do |format|
      format.html do
        @year_js = @end_time.year
        @week_js = @end_time.strftime("%W")
        @slots = [["7:00", "9:00"], ["9:00", "11:00"], ["11:00", "13:00"], ["13:00", "14:00"], ["14:00", "16:00"], ["16:00", "18:00"], ["18:00", "20:00"]]
        @days = (0..5)
      end
      format.json do
       render json: @events, methods: "_name"
     end
    end
  end
  
  def export
    events = current_user.events.where(start_time: Time.now..(Time.now + 6.months))
    respond_to do |format|
      format.ics do
        @cal = RiCal.Calendar do |cal|
          events.each do |event|
            cal.event do |cal_event|
              cal_event.summary     = event.name
              cal_event.description = event.description||""
              cal_event.dtstart     = event.start_time.getutc
              cal_event.dtend       = event.end_time.getutc
              cal_event.location    = event.location||""
              cal_event.url         = (event.course ? event.course.paul_url : "")
            end
          end
        end
        render text: @cal.to_s
      end
    end
  end

  def show
    @event = current_user.events.find(params[:id])
  end

  def update
  end
  
  protected
  def course_present?(course, user)
    user.events.each do |event|
      return true if event.course_id == course.id
    end
    false
  end
end
