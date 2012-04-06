class TransportationController < ApplicationController
  def index
    @trips = get_transportation_data
  end
  
  protected
  def get_transportation_data
    # naive approach, not for production
    data = Rails.cache.fetch('transportation_json_data', :expires_in => 2.minute) do
      result = JSON.parse(open("http://upbapi.cloudcontrolled.com/busplan.php").read)
      result.map do |trip| # mapping to make a DateTime object out of the "da" attribute. Can then be localized in view.
        trip["da"] = DateTime::strptime(trip["da"], "%Y-%m-%d %H:%M:%S")
        trip
      end
    end
    data
  end
end