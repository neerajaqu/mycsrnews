class AdminController < ApplicationController
  layout proc {|c| c.request.xhr? ? false : "new_admin" }

  before_filter :check_admin_or_default_status
  before_filter :set_current_tab

  def index
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

end
