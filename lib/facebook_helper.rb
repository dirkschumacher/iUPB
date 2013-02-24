class FacebookHelper

  def self.facebook_events(id)
    graph = Koala::Facebook::API.new(Facebook::TOKEN)
    events = graph.get_connections(id.to_s, "events").map do |event|
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
  end
  
  def self.facebook_events_multi(ids = [])
    ids.flat_map do |id|
      self.facebook_events(id)
    end
  end
  
end