class Admin::FeedsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Feed.active.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Feed,
    	:fields => [:title, :url, :rss, :created_at, :user_id],
    	:associations => { :belongs_to => { :user => :user_id } },
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @feed = Feed.find(params[:id])

    render_edit @feed
  end

  def update
    @feed = Feed.find(params[:id])
    if @feed.update_attributes(params[:feed])
      flash[:success] = "Successfully updated your Feed."
      redirect_to [:admin, @feed]
    else
      flash[:error] = "Could not update your Feed as requested. Please try again."
      render_edit @feed
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
      render_new @feed
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.update_attribute(:deleted_at, Time.now)

    redirect_to admin_feeds_path
  end

  private

  def render_new feed = nil
    feed ||= Feed.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => feed,
    	:model => Feed,
    	:fields => [:title, :url, :rss, :user_id],
    	:associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def render_edit feed
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => feed,
    	:model => Feed,
    	:fields => [:title, :url, :rss, :user_id],
    	:associations => { :belongs_to => { :user => :user_id } }
    }
  end


  def set_current_tab
    @current_tab = 'feeds';
  end

end
