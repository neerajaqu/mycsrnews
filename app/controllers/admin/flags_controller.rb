class Admin::FlagsController < AdminController
  layout 'new_admin'

  def index
    @flags = Flag.find(:all, :order => 'created_at desc')
#    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
#    	:items => Flag.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
#    	:model => Flag,
#    	:fields => [:item_title, :item_description, :user_id, :created_at, :flaggable],
#    	:associations => { :belongs_to => { :user => :user_id, :flaggable => :flaggable_id } },
#    	:paginate => true
#    }
  end

  def new
    @content = Content.new
  end

  def edit
    @content = Content.find(params[:id])
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
    @flag = Flag.find(params[:id])
    @flags = @flag.flaggable.flags
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
