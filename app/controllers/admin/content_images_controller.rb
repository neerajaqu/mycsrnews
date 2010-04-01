class Admin::ContentImagesController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => ContentImage.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => ContentImage,
    	:fields => [:url, :content_id, :created_at],
    	:associations => { :belongs_to => { :content => :content_id } },
    	:paginate => true
    }
  end

  def new
    @content_image = ContentImage.new
  end

  def edit
    @content_image = ContentImage.find(params[:id])
  end

  def update
    @content_image = ContentImage.find(params[:id])
    if @content_image.update_attributes(params[:content_image])
      flash[:success] = "Successfully updated your Content Image."
      redirect_to [:admin, @content_image]
    else
      flash[:error] = "Could not update your Content Image as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => ContentImage.find(params[:id]),
    	:model => ContentImage,
    	:fields => [:url, :content_id, :created_at],
    	:associations => { :belongs_to => { :content => :content_id } },
    }
  end

  def create
    @content_image = ContentImage.new(params[:content_image])
    @content_image.user = current_user
    if @content_image.save
      flash[:success] = "Successfully created your new Content Image!"
      redirect_to [:admin, @content_image]
    else
      flash[:error] = "Could not create your Content Image, please try again"
      render :new
    end
  end

  def destroy
    @content_image = ContentImage.find(params[:id])
    @content_image.destroy

    redirect_to admin_content_images_path
  end

  private

  def set_current_tab
    @current_tab = 'content_images';
  end

end
