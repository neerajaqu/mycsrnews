class Admin::TwitterSettingsController < AdminController

  def index
    set_vars
    begin
      @tweets = @twitter.user_timeline if @twitter
    rescue
      flash[:error] = "Bad authorization, please reset your keys and try again."
      @error = :bad_settings_error
    end
  end

  def update_keys
    @twitter_oauth_key = params[:twitter_oauth_key]
    @twitter_oauth_secret = params[:twitter_oauth_secret]
    unless @twitter_oauth_key.present? and @twitter_oauth_secret.present?
      set_vars
      ['oauth_key', 'oauth_secret'].each do |key|
        @form_errors["twitter_#{key}"] = "Twitter #{key.titleize} can't be blank." unless instance_variable_get("@twitter_#{key}").present?
      end
      flash[:error] = "Please fix the errors and resubmit your changes"
      render :index
    else
      Metadata::Setting.find_setting('oauth_key').update_value @twitter_oauth_key
      Metadata::Setting.find_setting('oauth_secret').update_value @twitter_oauth_secret
      flash[:success] = "Successfully updated your Twitter OAuth keys"

    	redirect_to admin_twitter_settings_path
    end
  end

  def update_auth
    set_vars
    @twitter_oauth_pin = params[:twitter_oauth_pin]
    unless @twitter_oauth_pin.present?
      @form_errors["twitter_oauth_pin"] = "Twitter OAuth Pin can't be blank."
      flash[:error] = "Please fix the errors and resubmit your changes"
      render :index
    else
      @oauth.authorize_from_request(params[:request_token], params[:request_secret], params[:twitter_oauth_pin])
      @oauth_consumer_key.update_value @oauth.access_token.token
      @oauth_consumer_secret.update_value @oauth.access_token.secret
      flash[:success] = "Successfully updated your Twitter OAuth keys"

    	redirect_to admin_twitter_settings_path
    end
  end

  def reset_keys
    set_vars
    @oauth_key.update_value @base_consumer_key
    @oauth_secret.update_value @base_consumer_secret
    @oauth_consumer_key.update_value @base_consumer_key
    @oauth_consumer_secret.update_value @base_consumer_secret
    flash[:error] = nil
    flash[:success] = "Successfully reset your keys"
    redirect_to admin_twitter_settings_path
  end

  private

  def set_current_tab
    @current_tab = 'settings'
  end

  def set_vars
    @oauth_key = Metadata::Setting.find_setting('oauth_key')
    @oauth_secret = Metadata::Setting.find_setting('oauth_secret')
    @oauth_consumer_key = Metadata::Setting.find_setting('oauth_consumer_key')
    @oauth_consumer_secret = Metadata::Setting.find_setting('oauth_consumer_secret')
    @base_consumer_key = 'U6qjcn193333331AuA'
    @base_consumer_secret = 'Heu0GGaRuzn762323gg0qFGWCp923viG8Haw'
    @extra_settings = Metadata::Setting.find(:all, :conditions => [ "key_sub_type like ?", 'twitter%' ] ).select {|k| k unless k.key_name =~ /oauth/}
    @error = nil
    @form_errors = {}
    ['key', 'secret', 'consumer_key', 'consumer_secret'].each do |key|
      val = instance_variable_get("@oauth_#{key}").try(:value)
      if not val or val.empty? or val == @base_consumer_key or val == @base_consumer_secret
      	@error = key =~ /^consumer/ ? :auth_error : :settings_error
      	break
      end
    end
    @oauth = Twitter::OAuth.new(@oauth_key.value, @oauth_secret.value) unless @error and @error == :settings_error
    if @oauth and @error == :auth_error
      unless params[:twitter_oauth_pin].present? 
        begin
          @request_token = @oauth.request_token
        rescue
          flash[:error] = "Bad authorization, please reset your keys and try again."
          @error = :bad_settings_error
        end
      end
    end
    unless @error
      @oauth.authorize_from_access(@oauth_consumer_key.value, @oauth_consumer_secret.value)
      begin
        @twitter = Twitter::Base.new(@oauth)
      rescue
        flash[:error] = "Bad authorization, please reset your keys and try again."
        @error = :bad_settings_error
      end
    end
  end

end
