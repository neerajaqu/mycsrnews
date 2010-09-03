class ResourcesController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?

  cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show, :my_resources]
  before_filter :login_required, :only => [:like, :new, :create, :update]
  before_filter :load_top_resources
  before_filter :load_newest_resources
  before_filter :set_resource_section
  before_filter :load_featured_resources, :only => [:index]
  before_filter :load_newest_resource_sections

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Resources'
    @resources = Resource.active.paginate :page => params[:page], :per_page => Resource.per_page, :order => "created_at desc"
    set_sponsor_zone('resources')
    respond_to do |format|
      format.html { @paginate = true }
      format.fbml { @paginate = true }
      format.atom
      format.json { @resources = Resource.refine(params) }
      format.fbjs { @resources = Resource.refine(params) }
    end
  end

  def new
    @current_sub_tab = 'Suggest Resource'
    @resource = Resource.new
    @resource.resource_section = @resource_section if @resource_section.present?
    @resources = Resource.active.newest
  end

  def create
    @resource = Resource.new(params[:resource])
    @resource.tag_list = params[:resource][:tags_string]
    @resource.twitterName = params[:resource][:twitterName].sub(/^http:\/\/(www.)*twitter.com\/+/,'').sub('@','')
    @resource.user = current_user

    if @resource.valid? and current_user.resources.push @resource
      if @resource.post_wall?
        session[:post_wall] = @resource
      end      
    	flash[:success] = "Thank you for adding to our directory!"
    	redirect_to resource_path(@resource)
    else
      @resources = Resource.active.newest
    	render :new
    end
  end

  def show
    @resource = Resource.find(params[:id])
    tag_cloud @resource
    set_outbrain_item @resource
    set_sponsor_zone('resources', @resource.item_title.underscore)
  end

  def my_resources
    @paginate = true
    @current_sub_tab = 'My Resources'
    @user = User.find(params[:id])
    @resources = @user.resources.active.paginate :page => params[:page], :per_page => Resource.per_page, :order => "created_at desc"
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @resources = Resource.tagged_with(tag_name, :on => 'tags').active.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    render :template => 'resources/index'
  end

  private

  def set_resource_section
     @resource_section = params[:resource_section_id].present? ? ResourceSection.find(params[:resource_section_id]) : nil
  end
   
  def set_current_tab
    @current_tab = 'resources'
  end


end
