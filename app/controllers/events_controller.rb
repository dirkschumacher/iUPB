class EventsController < ApplicationController
  before_filter :set_cache_header
  
  def index
    @events = Rails.cache.fetch("iUPB.fb_parties", :expires_in => 2.hours) do
      FacebookHelper::facebook_events("135017669880336") # 135017669880336 is https://www.facebook.com/uniparty.pb
    end
  end
end
