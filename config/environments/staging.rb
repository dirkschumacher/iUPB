IUPB::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=604800"

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  
  config.action_mailer.default_url_options = { :host => 'beta.i-upb.de' }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.time_zone = 'Berlin'


  # Serve pre-gzipped static assets
  config.middleware.insert_after(
   "Rack::Cache", "Middleware::CompressedStaticAssets",
   paths["public"].first, config.assets.prefix, config.static_cache_control)
  
  # https://devcenter.heroku.com/articles/paperclip-s3
  config.paperclip_defaults = {
     :storage => :s3,
     :s3_credentials => {
       :bucket => ENV['AWS_BUCKET'],
       :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
       :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
     }
   }

end
require 'newrelic_rpm'
def pp(*args)
  true
end

ENV["ios_webapp_notice"] = "true"
