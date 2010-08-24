class Admin::Metadata::SkipImagesController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::SkipImage.paginate(:page => params[:page], :per_page => 25, :order => "created_at desc"),
    	:model => Metadata::SkipImage,
    	:fields => [:image_url],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @skip_image = Metadata::SkipImage.find(params[:id])

    render_edit @skip_image
  end

  def update
    @skip_image = Metadata::SkipImage.find(params[:id])
    if @skip_image.update_attributes(params[:metadata_skip_image])
      flash[:success] = "Successfully updated your skip image."
      redirect_to admin_metadata_skip_image_path(@skip_image)
    else
      flash[:error] = "Could not update your skip image as requested. Please try again."
      render_edit @skip_image
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::SkipImage.find(params[:id]),
      :model => Metadata::SkipImage,
    	:fields => [:skip_image_name, :skip_image_sub_type_name, :skip_image_value, :created_at],
    }
  end

  def create
    @skip_image = Metadata::SkipImage.new(params[:metadata_skip_image])
    if @skip_image.save
      flash[:success] = "Successfully created your skip_image."
      redirect_to admin_metadata_skip_image_path(@skip_image)
    else
      flash[:error] = "Could not create your skip_image as requested. Please try again."
      render_new @skip_image
    end
  end
  
  def destroy
    @skip_image = Metadata::SkipImage.find(params[:id])
    @skip_image.destroy

    redirect_to admin_metadata_skip_images_path
  end

  private

  def render_new skip_image = nil
    skip_image ||= Metadata::SkipImage.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => skip_image,
    	:model => Metadata::SkipImage,
    	:fields => [:image_url]
    }
  end

  def render_edit skip_image
    skip_image ||= Metadata::SkipImage.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => skip_image,
    	:model => Metadata::SkipImage,
    	:fields => [:image_url]
    }
  end

  def set_current_tab
    @current_tab = 'skip_images';
  end

end
