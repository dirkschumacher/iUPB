class AstaController < ApplicationController
  def index
    set_cache_header 60*20
  end
  
  protected
  def get_news_data
    # needs also a change in the api - horrible :)
    data = Rails.cache.fetch('asta_json_data', :expires_in => 20.minute) do
      #result = JSON.parse(open("--------------------------").read)
      #result["time"] = DateTime::strptime(result["time"], "%d.%m.%Y, %H:%M Uhr")
    end
    data
  end
end
