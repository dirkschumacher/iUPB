class PagesController < HighVoltage::PagesController
  before_filter :set_cache_header
  
  protected
  def set_cache_header
    response.headers['Cache-Control'] = 'public, max-age=604800'
  end
end
