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
    if @dashboardMessage.update_attributes(params[:dashboardMessage])
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
    	:fields => [:message, :action_text, :action_url, :image_url, :status],
    }
  end

  def create
    @dashboardMessage = DashboardMessage.new(params[:dashboardMessage])
    if @dashboardMessage.save
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
    	:item => @dashboardMessage,
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status]
      }
  end
  
  def render_edit dashboardMessage
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => dashboardMessage,
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status]
    }
  end  
  private

  def set_current_tab
    @current_tab = 'dashboard-messages';
  end

end
