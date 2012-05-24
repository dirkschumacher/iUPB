class EventsController < ApplicationController
  before_filter :set_cache_header
  
  def index
    @events = Rails.cache.fetch("iUPB.fb_parties", :expires_in => 1.hour) do
      graph = Koala::Facebook::API.new(Facebook::TOKEN)

      # 135017669880336 is https://www.facebook.com/uniparty.pb
     events = graph.get_connections("135017669880336", "events").map do |event|
        event["start_time"] = DateTime::strptime(event["start_time"]+"T+0200", "%Y-%m-%dT%H:%M:%ST%z")
        event["end_time"] = DateTime::strptime(event["end_time"]+"T+0200", "%Y-%m-%dT%H:%M:%ST%z")
        event["link"] = "https://www.facebook.com/events/" + event["id"]
        event["attendees"] = graph.get_connections(event["id"], "attending").count if event["start_time"] > DateTime.now
        event
      end
      events.sort! { |l, r| l["start_time"]<=>r["start_time"] } # necessary?
    #  @events = events
    end
  end
end
