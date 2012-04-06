class WeatherController < ApplicationController
  def index
    @weatherData = get_weather_data
  end
  
  protected
  def get_weather_data
    # needs also a change in the api - horrible :)
    data = Rails.cache.fetch('weather_json_data', :expires_in => 15.minute) do
      result = JSON.parse(open("http://upbapi.cloudcontrolled.com/wetter.php").read)
      #result["time"] = DateTime::strptime(result["time"], "%d.%m.%Y, %H:%M Uhr")
    end
    data.first
  end
end
