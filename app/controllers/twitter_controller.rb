class TwitterController < ApplicationController
  def data
    data = Rails.cache.fetch('twitter_json_data', :expires_in => 10.second) do
      open("https://search.twitter.com/search.json?q=%23upb&lang=de").read
    end
    render :json => data
  end
end
