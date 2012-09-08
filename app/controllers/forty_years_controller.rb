class FortyYearsController < ApplicationController
  
  def index
    @events = FortyYearsEvent.all.order(:start_time)
    respond_to do |format|
      format.html do
        @slots = [["7:00", "9:00"], ["9:00", "11:00"], ["11:00", "13:00"], ["13:00", "14:00"], ["14:00", "16:00"], ["16:00", "18:00"], ["18:00", "20:00"]]
        @days = (0..15)
      end
      format.json do
       render json: @events
     end
    end
  end
  def facts
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
  
  protected
  def course_present?(course, user)
    user.events.each do |event|
      return true if event.course_id == course.id
    end
    false
  end
end
