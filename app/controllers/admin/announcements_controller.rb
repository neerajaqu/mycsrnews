class Admin::AnnouncementsController < AdminController
  skip_before_filter :admin_user_required
#  cache_sweeper :widget_sweeper, :only => [:create,:update,:destroy]
# TODO - ask RB    WidgetSweeper.expire_all

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Announcement.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Announcement,
    	:fields => [:prefix, :title, :url, :created_at],
    	:paginate => true
    }
  end

  def new
    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:model => Announcement,
    	:fields => [:prefix, :title, :details, :url, :type]
    }
  end

  def edit
    @announcement = Announcement.find(params[:id])
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => @announcement,
    	:model => Announcement,
    	:fields => [:prefix, :title, :details, :url, :type]
    }
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      flash[:success] = "Successfully updated your Announcement."
      redirect_to [:admin, @announcement]
    else
      flash[:error] = "Could not update your Announcement as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Announcement.find(params[:id]),
    	:model => Announcement,
    	:fields => [:prefix, :title, :details, :url, :type,:created_at]
    }
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      flash[:success] = "Successfully created your new Announcement!"
      redirect_to [:admin, @announcement]
    else
      flash[:error] = "Could not create your Announcement, please try again"
      render :new
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    redirect_to admin_announcements_path
  end

  private

  def set_current_tab
    @current_tab = 'announcements';
  end

end
