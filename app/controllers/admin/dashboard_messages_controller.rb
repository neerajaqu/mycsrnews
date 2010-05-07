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
    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status, :created_at],
    }
  end

  def edit
    @dashboardMessage = DashboardMessage.find(params[:id])
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => @dashboardMessage,
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status, :created_at],
    }
  end

  def update
    @dashboardMessage = DashboardMessage.find(params[:id])
    if @dashboardMessage.update_attributes(params[:DashboardMessage])
      flash[:success] = "Successfully updated your DashboardMessage."
      redirect_to [:admin, @dashboardMessage]
    else
      flash[:error] = "Could not update your DashboardMessage as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => DashboardMessage.find(params[:id]),
    	:model => DashboardMessage,
    	:fields => [:message, :action_text, :action_url, :image_url, :status, :created_at],
    }
  end

  def create
    @dashboardMessage = DashboardMessage.new(params[:DashboardMessage])
    if @dashboardMessage.save
      flash[:success] = "Successfully created your new DashboardMessage!"
      redirect_to [:admin, @dashboardMessage]
    else
      flash[:error] = "Could not create your DashboardMessage, please try again"
      redirect_to new_admin_dashboard_message_path
    end
  end

  def destroy
    @dashboardMessage = DashboardMessage.find(params[:id])
    @dashboardMessage.destroy
    redirect_to admin_dashboard_messages_path
  end

  private

  def set_current_tab
    @current_tab = 'dashboard-messages';
  end

end
