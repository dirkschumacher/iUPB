module Facebook
  
  CONFIG = YAML.load(ERB.new(File.new(Rails.root.join("config/facebook.yml")).read).result)[Rails.env]
  APP_ID = CONFIG['app_id']
  SECRET = CONFIG['secret_key']
  TOKEN = CONFIG['token']
end