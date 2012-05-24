class WeatherController < ApplicationController
  def index
    set_cache_header 60*20
    #@weatherData = get_weather_data
    forecast = get_forecast
    if forecast['city']['forecast'][Time.now.strftime("%Y-%m-%d")]
      @forecast_temp = forecast['city']['forecast'][Time.now.strftime("%Y-%m-%d")]['tx']
      @forecast_text = forecast['city']['forecast'][Time.now.strftime("%Y-%m-%d")]['w_txt']
    else
      @forecast_temp = nil
      @forecast_text = nil
    end
  end
  
  protected
  def get_forecast
    Rails.cache.fetch("iUPB.wettercom_api", :expires_in => 1.hour) do
      project = "iupb"
      api_key = "6be11e5256109145398267ed1e953102"
      citycode = "DE0008110"
      checksum = Digest::MD5.hexdigest(project+api_key+citycode)
      url = "/forecast/weather/city/"+citycode+"/project/"+project+"/cs/"+checksum+"/output/json"
      ::Yajl::Parser.parse(open("http://api.wetter.com"+url))
    end
  end
end
