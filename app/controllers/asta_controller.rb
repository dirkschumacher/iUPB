class AstaController < ApplicationController
  MINUTES = 30
  
  def index
    @news_items = get_news_data
    set_cache_header 60 * AstaController::MINUTES
  end
  def data
    @items = get_news_data
    respond_to do |format|
      format.xml
      format.json
    end
  end
  protected
  def get_news_data
    # needs also a change in the api - horrible :)
    Rails.cache.fetch('iUPB.asta_xml_data', :expires_in => AstaController::MINUTES.minute) do
      doc = Nokogiri::XML(open("http://asta.uni-paderborn.de/?type=100"))
      doc.search('//rss/channel/item').map do |item|
        data = {}
        data['title'] =  item.search('title').first.text.strip
        data['link'] =  item.search('link').first.text if item.search('link').first
        data['description'] =  item.search('description').first.text.strip if item.search('description').first
        data['date'] =  DateTime::strptime(item.search('pubDate').first.text.strip, "%a, %d %b %Y %H:%M:%S %z")
        data
      end
    end
  end
end
