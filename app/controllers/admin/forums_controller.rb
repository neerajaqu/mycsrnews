class Admin::ForumsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Forum.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Forum,
    	:fields => [:name, :description, :topics_count, :comments_count, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @forum = Forum.find(params[:id])

    render_edit @forum
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      flash[:success] = "Successfully updated your Forum."
      redirect_to [:admin, @forum]
    else
      flash[:error] = "Could not update your Forum as requested. Please try again."
      render_edit @forum
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Forum.find(params[:id]),
    	:model => Forum,
    	:fields => [:name, :description, :topics_count, :comments_count, :created_at],
    }
  end

  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:success] = "Successfully created your new Forum!"
      redirect_to [:admin, @forum]
    else
      flash[:error] = "Could not create your Forum, please try again"
      render_new @forum
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    redirect_to admin_forums_path
  end

  private

  def render_new forum = nil
    forum ||= Forum.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @forum,
    	:model => Forum,
    	:fields => [:name, :description],
    }
  end

  def render_edit forum
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => forum,
    	:model => Forum,
    	:fields => [:name, :description],
    	:associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def set_current_tab
    @current_tab = 'forums';
  end

end
