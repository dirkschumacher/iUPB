class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  protected
  
  # caches content for 4 hours via varnish. 
  # use in as method or as a filter
  def set_cache_header(duration=14400) 
    response.headers['Cache-Control'] = "public, max-age=#{duration.to_s}"
  end
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
