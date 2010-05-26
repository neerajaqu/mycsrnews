class Admin::TopicsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Topic.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Topic,
    	:fields => [:title, :comments_count, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @topic = Topic.find(params[:id])

    render_edit @topic
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      flash[:success] = "Successfully updated your Topic."
      redirect_to [:admin, @topic]
    else
      flash[:error] = "Could not update your Topic as requested. Please try again."
      render_edit @topic
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Topic.find(params[:id]),
    	:model => Topic,
    	:fields => [:title, :comments_count, :created_at],
    }
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:success] = "Successfully created your new Topic!"
      redirect_to [:admin, @topic]
    else
      flash[:error] = "Could not create your Topic, please try again"
      render_new @topic
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    redirect_to admin_topics_path
  end

  private

  def render_new topic = nil
    topic ||= Topic.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @topic,
    	:model => Topic,
    	:fields => [:title, :forum_id],
    	:associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
    }
  end

  def render_edit topic
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => topic,
    	:model => Topic,
    	:fields => [:title],
    	:associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
    }
  end

  def set_current_tab
    @current_tab = 'topics';
  end

end
