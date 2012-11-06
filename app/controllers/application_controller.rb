class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :set_custom_params
  
  def default_url_options(options={})
    if canvas?
      { :locale => I18n.locale, :canvas => "true"}    #I know it's redundant :)
    else
      { :locale => I18n.locale}
    end
  end

  def canvas?
    return false if params[:canvas] == "false"
    params[:canvas] == "true" || session[:canvas]
  end
  helper_method :canvas?

  # Can check for a specific user agent
  # e.g., is_device?('iphone') or is_device?('mobileexplorer')
  def is_device?(type)
    request.user_agent.to_s.downcase.include?(type.to_s.downcase)
  end
  helper_method :is_device?

  def is_mobile?
    mobile_browsers.each do |mb|
      return true if is_device?(mb)
    end
    return false
  end
  helper_method :is_mobile?

  protected

  def mobile_browsers
    ["android", "ipod", "ipad", "iphone", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  end
  
  # caches content for 1 hour via varnish. 
  # use in as method or as a filter
  def set_cache_header(duration=3600) 
    response.headers['Cache-Control'] = "public, max-age=#{duration.to_s}" if params[:locale] && !user_signed_in? && flash.empty?
  end
  
  def set_custom_params
    session[:canvas] = true if params[:canvas] == "true"
    session[:canvas] = nil if params[:canvas] == "false"
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  # use as a filter
  def only_upb_ip
    upb_net = "131.234.0.0/16"
    upb = IPAddr.new(upb_net)
    upb === request.remote_ip
  end
  
  def fb_graph(url)
    Koala::Facebook::API.new(Koala::Facebook::OAuth.new(
      Facebook::APP_ID.to_s, 
      Facebook::SECRET.to_s, 
      url))
  end
  
end
