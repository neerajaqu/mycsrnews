class Admin::CommentsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Comment.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Comment,
    	:fields => [:comments, :user_id, :created_at],
    	:associations => { :belongs_to => { :user => :user_id } },
    	:paginate => true
    }
  end

  def new
    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:model => Comment,
    	:fields => [:comments, :postedByName, :created_at],
    }
  end

  def edit
    @Comment = Comment.find(params[:id])
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => @Comment,
    	:model => Comment,
    	:fields => [:comments, :created_at],
    }
  end

  def update
    @Comment = Comment.find(params[:id])
    if @Comment.update_attributes(params[:Comment])
      flash[:success] = "Successfully updated your Comment."
      redirect_to [:admin, @Comment]
    else
      flash[:error] = "Could not update your Comment as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Comment.find(params[:id]),
    	:model => Comment,
    	:fields => [:comments, :postedByName, :created_at],
    }
  end

  def create
    @Comment = Comment.new(params[:Comment])
    if @Comment.save
      flash[:success] = "Successfully created your new Comment!"
      redirect_to [:admin, @Comment]
    else
      flash[:error] = "Could not create your Comment, please try again"
      render :new
    end
  end

  def destroy
    @Comment = Comment.find(params[:id])
    @Comment.destroy

    redirect_to admin_Comments_path
  end

  private

  def set_current_tab
    @current_tab = 'Comments';
  end

end
