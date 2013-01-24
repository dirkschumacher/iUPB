class AdMailer < ActionMailer::Base
  default from: "noreply@i-upb.de"
  
  def ad_created_email(ad)
    @ad = ad
    mail(:to => ad.email, :subject => "#{ad.title.truncate(30)} @ iUPB - Links")
  end
end
