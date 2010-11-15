class AdminController < ApplicationController
  layout proc {|c| c.request.xhr? ? false : "new_admin" }

  before_filter :check_admin_or_default_status
  before_filter :set_current_tab
  before_filter :check_iframe

  def index
    # Loads dashboard
    # TODO:: make the dashboard actually a dashboard
    #redirect_to admin_contents_path
  end

  private

  def set_current_tab
    @current_tab = 'dashboard'
  end

  def check_admin_or_default_status
    return true if current_user and current_user.is_admin?

    if User.find_admin_users.empty?
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['default_admin_user'] and password == APP_CONFIG['default_admin_password']
      end
    else 
      redirect_to home_index_path and return false
    end
  end

  def find_moderatable_item
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

  def check_iframe
    if @iframe_status
    	@iframe_status = false
    	redirect_to admin_path and return false
    end
  end

end
