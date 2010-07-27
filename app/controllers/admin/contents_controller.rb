class Admin::ContentsController < AdminController

  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Content.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Content,
    	:fields => [:title, :user_id, :score, :comments_count, :is_blocked, :created_at],
    	:associations => { :belongs_to => { :user => :user_id, :source => :source } },
    	:paginate => true
    }
  end

  def new
    @content = Content.new
  end

  def edit
    @content = Content.find(params[:id])
# todo: not completed
#    render_edit @content
  end

  def update
    @content = Content.find(params[:id])
    if @content.update_attributes(params[:content])
      flash[:success] = "Successfully updated your Content."
      redirect_to [:admin, @content]
    else
      flash[:error] = "Could not update your Content as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Content.find(params[:id]),
    	:model => Content,
    	:fields => [:title, :user_id, :url, :caption, :content_image, :source, :score, :comments_count, :is_blocked, :created_at],
    	:associations => { :belongs_to => { :user => :user_id , :source => :source}, :has_one => { :content_image => :content_image} },
    }
  end

  def create
    @content = Content.new(params[:content])
    @content.user = current_user
    @story.tag_list = params[:content][:tags_string]
    if params[:content][:image_url].present?
      @story.build_content_image({:url => params[:content][:image_url]})
    end
    if @content.save
      flash[:success] = "Successfully created your new Content!"
      redirect_to [:admin, @content]
    else
      flash[:error] = "Could not create your Content, please try again"
      render :new
    end
  end

  def render_edit content
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => content,
    	:model => Content,
    	:fields => [:title, :user_id, :url, :caption, :source, :score, :comments_count, :is_blocked, :created_at],
    	:associations => { :belongs_to => { :user => :user_id , :source => :source}, :has_one => { :content_image => :content_image} },
    }
  end

  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    redirect_to admin_contents_path
  end

  private

  def set_current_tab
    @current_tab = 'contents';
  end

end
