ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL'] if ENV['BONSAI_URL']

if ENV['ELASTICSEARCH_URL']
  Tire.configure do  # is this really needed?
    url ENV['ELASTICSEARCH_URL']
  end
end