class TwitterController < ApplicationController
	def feed
		@tweets = get_tweets
	end
	
	private
	def get_tweets
  	  Rails.cache.fetch("iUPB.tweets", :expires_in => 5.seconds) do
  	    Twitter.search("%23upb+OR+%23unipb+OR+%23unipaderborn+OR+%23iupb", :lang => "de").results
      end
  end
end