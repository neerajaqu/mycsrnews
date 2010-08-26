class OauthController < ApplicationController
  #before_filter :login_required

  def new
    session[:at]=nil
    redirect_to authenticator.authorize_url(:scope => 'publish_stream', :display => 'page')
  end
  
  def create    
    mogli_client = Mogli::Client.create_from_code_and_authenticator(params[:code],authenticator)
    session[:at]=mogli_client.access_token
    current_user.update_attribute(:fb_oauth_key, mogli_client.access_token)
    redirect_to "/"
  end
  
  def index
    redirect_to new_oauth_path and return unless session[:at]
    user = Mogli::User.find("me",Mogli::Client.new(session[:at]))
    @user = user
    @posts = user.posts
  end
  
  def authenticator
    @authenticator ||= Mogli::Authenticator.new(APP_CONFIG['facebook_application_id'], Facebooker.secret_key, oauth_callback_url)
  end
end
