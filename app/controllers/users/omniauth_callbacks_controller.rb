class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    try_login_user "Facebook"
  end

  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    try_login_user "Google"
  end
  
  private 
  
  def try_login_user(kind)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise." + kind.downcase + "_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end