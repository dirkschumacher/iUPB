class WeatherController < ApplicationController
  def index
    @weatherData = get_weather_data
    @forecast = get_forecast
  end
  
  protected
  def get_weather_data
    # needs also a change in the api - horrible :)
    data = Rails.cache.fetch('weather_json_data', :expires_in => 10.minute) do
      result = JSON.parse(open("http://upbapi.cloudcontrolled.com/wetter.php").read)
      #result["time"] = DateTime::strptime(result["time"], "%d.%m.%Y, %H:%M Uhr")
    end
    data
  end
   
  def get_forecast
    project = "iupb"
    api_key = "6be11e5256109145398267ed1e953102"
    citycode = "DE0008110"
    checksum = Digest::MD5.hexdigest(project+api_key+citycode)
    url = "/forecast/weather/city/"+citycode+"/project/"+project+"/cs/"+checksum+"/output/json"
    ::Yajl::Parser.parse(open("http://api.wetter.com"+url))
  end
end
