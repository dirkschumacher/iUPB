class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  protected
  
  # caches content for 1 day via varnish. 
  # use in as method or as a filter
  def set_cache_header(duration=86400) 
    response.headers['Cache-Control'] = "public, max-age=#{duration.to_s}"
  end
end
