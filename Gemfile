source 'https://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'heroku'
gem 'bson_ext' # MongoDB performance
gem 'mongoid'
#gem "bing_translator", "~> 0.0.2"
gem 'rack-contrib', :require => 'rack/contrib'
gem 'i18n-js'
gem 'devise'
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem 'rabl'
gem 'yajl-ruby', :require => "yajl"
gem "koala"
gem "rack-offline", :git => "git://github.com/wycats/rack-offline.git"
gem "haml"
gem "ri_cal"

gem "js-routes" # https://github.com/railsware/js-routes


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
	gem 'newrelic_rpm'
	gem 'dalli'
	gem 'kgio'
end
group :staging do
	gem "thin"
	gem 'newrelic_rpm'
	gem 'dalli'
	gem 'kgio'
end


gem 'jquery-rails'
gem 'twitter-bootstrap-rails'

gem "high_voltage"

gem "nokogiri"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
