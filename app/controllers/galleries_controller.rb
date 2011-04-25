class GalleriesController < ApplicationController
  cache_sweeper :gallery_sweeper, :only => [:create, :update, :destroy, :add_gallery_item]
  before_filter :login_required, :only => [:new, :create, :edit, :update, :add_gallery_item]
  before_filter :check_valid_user, :only => [:edit, :update]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @paginate = true
    @galleries = Gallery.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
  end

  def show
    @gallery = Gallery.find(params[:id])
    tag_cloud @gallery
  end

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.set_user current_user
    if @gallery.valid? and current_user.galleries.push @gallery
      if @gallery.post_wall?
        session[:post_wall] = @gallery
      end
      flash[:success] = "Successfully posted your gallery!"
      redirect_to @gallery
    else
    	flash[:error] = "Could not create your gallery. Please clear the errors and try again."
    	render :new
    end
  end

  def edit
    @gallery ||= Gallery.find(params[:id])
  end

  def update
    @gallery ||= Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
    	flash[:success] = "Successfully updated your Gallery."
    	redirect_to @gallery
    else
    	flash[:error] = "Could not update your Gallery. Please fix the errors and try again"
    	render :edit
    end
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @galleries = Gallery.active.tagged_with(tag_name, :on => 'tags').paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def add_gallery_item
    @gallery = Gallery.find(params[:id])

    unless @gallery.user == current_user or @gallery.is_public?
      flash[:error] = "You are not authorized to modify this gallery."
      redirect_to @gallery and return
    end

    if request.post?
      @gallery_item = GalleryItem.new(params[:gallery_item])
      @gallery_item.gallery = @gallery
      @gallery_item.user = current_user

      if @gallery_item.save
        flash[:success] = "Successfully added your gallery item"
        redirect_to @gallery
      else
        flash[:error] = "Could not add your gallery item. Please clear the errors and try again"
        render
      end
    else
      @gallery_item = GalleryItem.new
    end
  end

  private

  def check_valid_user
    @gallery = Gallery.find(params[:id])
    unless current_user and (@gallery.user == current_user or current_user.is_moderator?)
      flash[:error] = "You are not authorized for that gallery."
      redirect_to @gallery and return false
    end
  end

  def set_current_tab
    @current_tab = 'galleries'
  end

end
