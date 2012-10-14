if Rails.env.production? || Rails.env.staging?
	ActionMailer::Base.smtp_settings = {
	  :port           => ENV['MAILGUN_SMTP_PORT'], 
	  :address        => ENV['MAILGUN_SMTP_SERVER'],
	  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
	  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
	  :domain         => 'iupb.herokuapp.com',
	  :authentication => :plain,
	}
	ActionMailer::Base.delivery_method = :smtp
end