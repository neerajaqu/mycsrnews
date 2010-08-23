class Admin::ImagesController < AdminController

  def index
    @images = Image.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc")
  end

  def new
    render_new
  end

  def edit
    @image = Image.find(params[:id])

    render_edit @image
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:success] = "Successfully updated your Image."
      redirect_to [:admin, @image]
    else
      flash[:error] = "Could not update your Image as requested. Please try again."
      render_edit @image
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Image.find(params[:id]),
    	:model => Image,
    	:fields => [:title, :url, :rss, :created_at],
    }
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      flash[:success] = "Successfully created your new Image!"
      redirect_to [:admin, @image]
    else
      flash[:error] = "Could not create your Image, please try again"
      render_new @image
    end
  end

  def destroy
    @ignore = params[:ignore].present? and params[:ignore]
    @image = Image.find(params[:id])
    @imageable = @image.imageable
    if @ignore and @image.remote_image_url
    	Metadata::SkipImage.create({:image_url => @image.remote_image_url})
    end
    if @image.destroy
    	expire_cache @imageable
    	WidgetSweeper.expire_features
    end

    respond_to do |format|
      format.html { redirect_to admin_images_path }
      format.json { render :json => {}, :status => 200 }
    end
  end

  private

  def render_new image = nil
    image ||= Image.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => image,
    	:model => Image,
    	:fields => [:title, :url, :rss, :user_id],
    	:associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def render_edit image
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => image,
    	:model => Image,
    	:fields => [:title, :url, :rss, :user_id],
    	:associations => { :belongs_to => { :user => :user_id } }
    }
  end


  def set_current_tab
    @current_tab = 'images';
  end

end
