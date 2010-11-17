class Admin::DashboardMessagesController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => DashboardMessage.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => DashboardMessage,
    	:fields => [:message, :status, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @dashboardMessage = DashboardMessage.find(params[:id])
    render_edit @dashboardMessage
  end

  def update
    @dashboardMessage = DashboardMessage.find(params[:id])
    if @dashboardMessage.update_attributes(params[:dashboard_message])
      flash[:success] = "Successfully updated your DashboardMessage."
      redirect_to [:admin, @dashboardMessage]
    else
      flash[:error] = "Could not update your DashboardMessage as requested. Please try again."
      render_edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => DashboardMessage.find(params[:id]),
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status, :news_id],
    }
  end

  def create
    @dashboardMessage = DashboardMessage.new(params[:dashboard_message])
    @dashboardMessage.user = current_user
    if @dashboardMessage.valid? and current_user.dashboard_messages.push @dashboardMessage
      flash[:success] = "Successfully created your new Dashboard Message!"
      redirect_to [:admin, @dashboardMessage]
    else
      flash[:error] = "Could not create your Dashboard Message, please try again"
      render_new @dashboardMessage
    end
  end

  def destroy
    @dashboardMessage = DashboardMessage.find(params[:id])
    @dashboardMessage.destroy
    redirect_to admin_dashboard_messages_path
  end

  def render_new dashboardMessage = nil
    dashboardMessage ||= DashboardMessage.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => dashboardMessage,
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url]
      }
  end
  
  def render_edit dashboardMessage
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => dashboardMessage,
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url]
    }
  end  

  def clear_global 
    if params[:id]
      @dashboardMessage = DashboardMessage.find(params[:id])
      unless @dashboardMessage
        flash[:error] = "Invalid dashboard message"
        redirect_to admin_dashboard_messages_path
      end
      result = facebook_session.application.clear_global_news @dashboardMessage.news_id
      @dashboardMessage.set_draft! result
    else
      result = facebook_session.application.clear_global_news
      # clear status of all dashboard messages
      @dashboardMessage = DashboardMessage.find(:all)
      @dashboardMessage.each do |dashboardMessage|
        dashboardMessage.set_draft! dashboardMessage.news_id
      end
    end
    
    User.find_in_batches(:batch_size => 100) do |users|
      Facebooker::User.multi_clear_news users.inject({}) {|arr,u| arr[u.fb_user_id.to_s] = []; arr}
      Facebooker::User.dashboard_multi_set_count users.inject({}) {|arr,u| arr[u.fb_user_id.to_s] = 0; arr}
    end
         
#    if result =~ /^[0-9]+$/
      flash[:success] = "Successfully cleared the message(s)"
      redirect_to admin_dashboard_messages_path
#    else
#    	flash[:error] = "Could not clear the message(s)"
#      redirect_to admin_dashboard_messages_path
#    end
  end
  
  def send_global
    @dashboardMessage = DashboardMessage.find(params[:id])
    unless @dashboardMessage
      flash[:error] = "Invalid dashboard message"
      redirect_to admin_dashboard_messages_path
    end

    result = facebook_session.application.add_global_news(@dashboardMessage.build_news, @dashboardMessage.image_url)
    if result =~ /^[0-9]+$/
      @dashboardMessage.set_success! result
      flash[:success] = "Successfully sent your message"
      redirect_to admin_dashboard_messages_path
    else
    	flash[:error] = "Could not send your message"
      redirect_to admin_dashboard_messages_path
    end
  end

  private

  def set_current_tab
    @current_tab = 'dashboard-messages';
  end

end
