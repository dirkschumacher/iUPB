class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
  protected
  def set_cache_header
    response.headers['Cache-Control'] = 'public, max-age=86400'
  end
end
