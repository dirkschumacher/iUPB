class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  protected
  
  # caches content for 1 hour via varnish. 
  # use in as method or as a filter
  def set_cache_header(duration=3600) 
    response.headers['Cache-Control'] = "public, max-age=#{duration.to_s}" if params[:locale]
  end
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  # use as a filter
  def only_upb_ip
    upb_net = "131.234.0.0/16"
    upb = IPAddr.new(upb_net)
    upb === request.ip_address
  end
  
  def fb_graph(url)
    Koala::Facebook::API.new(Koala::Facebook::OAuth.new(
      Facebook::APP_ID.to_s, 
      Facebook::SECRET.to_s, 
      url))
  end
end
