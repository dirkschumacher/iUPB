source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'heroku'
gem 'bson_ext' # MongoDB performance
gem 'mongoid'
#gem "bing_translator", "~> 0.0.2"
gem 'rack-contrib', :require => 'rack/contrib'
gem 'i18n-js'
gem 'devise', '>= 2.1.2'
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem 'rabl'
gem 'yajl-ruby', :require => "yajl"
gem "koala"
gem "rack-offline", :git => "git://github.com/wycats/rack-offline.git"
gem "haml"
gem "recaptcha", :require => "recaptcha/rails"
gem "ri_cal"
gem "ruby-oembed", "~> 0.8.8" 
gem 'mongoid_slug', :git => "git://github.com/digitalplaywright/mongoid-slug.git", ref: "7f99b27b26d460a5e12bba9accccd1dd215073c8" # Mongoid2 /  https://github.com/digitalplaywright/mongoid-slug/issues/100#issuecomment-10030053

gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem "tire"

gem "js-routes" # https://github.com/railsware/js-routes
gem 'contact_us', '~> 0.4.0.beta' # https://github.com/jdutil/contact_us

# gem "historyjs-rails"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes

  gem 'uglifier', '>= 1.0.3'
end

group :development do
	gem "rails_admin"
	gem 'pry-rails'   # a nicer 'rails console'
	gem 'quiet_assets'
end

group :production do
	gem "thin"
	gem 'newrelic_rpm', '>= 3.5.3.25'
	gem 'dalli'
	gem 'kgio'
	gem "aws-sdk"
end
group :staging do
	gem "unicorn"
	gem 'newrelic_rpm', '>= 3.5.3.25'
	gem 'dalli'
	gem 'kgio'
	gem "aws-sdk"
end


gem 'jquery-rails'
gem 'jquery-cookie-rails'
gem 'twitter-bootstrap-rails', '2.0.9'

gem "high_voltage"
gem "will_paginate_mongoid"
gem 'bootstrap-will_paginate'

gem "nokogiri"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
