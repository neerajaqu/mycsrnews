class Admin::FeedsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Feed.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Feed,
    	:fields => [:title, :url, :rss, :created_at],
    	:paginate => true
    }
  end

  def new
    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:model => Feed,
    	:fields => [:title, :url, :rss]
    }
  end

  def edit
    @feed = Feed.find(params[:id])
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => @feed,
    	:model => Feed,
    	:fields => [:title, :url, :rss]
    }
  end

  def update
    @feed = Feed.find(params[:id])
    if @feed.update_attributes(params[:feed])
      flash[:success] = "Successfully updated your Feed."
      redirect_to [:admin, @feed]
    else
      flash[:error] = "Could not update your Feed as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Feed.find(params[:id]),
    	:model => Feed,
    	:fields => [:title, :url, :rss, :created_at],
    }
  end

  def create
    @feed = Feed.new(params[:feed])
    if @feed.save
      flash[:success] = "Successfully created your new Feed!"
      redirect_to [:admin, @feed]
    else
      flash[:error] = "Could not create your Feed, please try again"
      render :new
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    redirect_to admin_feeds_path
  end

  private

  def set_current_tab
    @current_tab = 'feeds';
  end

end
