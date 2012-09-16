class FortyYearsController < ApplicationController
  
  def index
    @events = FortyYearsEvent.all.order(:start_time)
    @facts = FortyYearsFact.all
    respond_to do |format|
      format.html do
        @slots = [["8:00", "11:00"], ["11:00", "14:00"], ["14:00", "16:00"], ["16:00", "18:00"], ["18:00", "20:00"], ["20:00", "23:00"]]
        @days = [0] + (22..28).to_a + [0] + (29..31).to_a + (1..4).to_a
      end
      format.json do
       render json: @events
     end
    end
  end
  def random_fact
    fact = FortyYearsFact.find
    render json: {id: fact.id, text: fact.text}
  end

  def export
    events = FortyYearsEvent.all
    respond_to do |format|
      format.ics do
        @cal = RiCal.Calendar do |cal|
          events.each do |event|
            cal.event do |cal_event|
              cal_event.summary     = event.name
              cal_event.description = event.description||""
              cal_event.dtstart     = event.start_time.change({hour: event.start_time.hour - 2}).getutc
              cal_event.dtend       = event.end_time.change({hour: event.end_time.hour - 2}).getutc
              cal_event.location    = event.location||""
              cal_event.url         = event.link
            end
          end
        end
        render text: @cal.to_s
      end
    end
  end
  
end
