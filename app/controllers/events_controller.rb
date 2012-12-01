class EventsController < ApplicationController
  before_filter :set_cache_header
  
  def index
    @events = Rails.cache.fetch("iUPB.fb_parties", :expires_in => 2.hours) do
      graph = Koala::Facebook::API.new(Facebook::TOKEN)

      # 135017669880336 is https://www.facebook.com/uniparty.pb
     events = graph.get_connections("135017669880336", "events").map do |event|
       begin
         
         event["start_time"] = event["start_time"] + "T21:00:00" if event["start_time"].length <= 10

         unless event["start_time"].include?("+")
           event["start_time"] = DateTime::strptime(event["start_time"]+"T+0100", "%Y-%m-%dT%H:%M:%ST%z")
           if event["end_time"]
             event["end_time"] = DateTime::strptime(event["end_time"]+"T+0100", "%Y-%m-%dT%H:%M:%ST%z")
          else
            event["end_time"] = event["start_time"]
          end
         else
           event["start_time"] = DateTime::strptime(event["start_time"].to_s, "%Y-%m-%dT%H:%M:%S%z")
           if event["end_time"]
              event["end_time"] = DateTime::strptime(event["end_time"].to_s, "%Y-%m-%dT%H:%M:%S%z")
           else
             event["end_time"] = event["start_time"]
           end
         end
       end
       event["link"] = "https://www.facebook.com/events/" + event["id"]
       event["attendees"] = graph.get_connections(event["id"], "attending").count if event["start_time"] > DateTime.now
       event
      end
      events.sort! { |l, r| l["start_time"]<=>r["start_time"] } # necessary?
    #  @events = events
    end
  end
end
