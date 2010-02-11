class ResourcesController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:new, :create, :update]
  before_filter :load_top_resources
  before_filter :load_newest_resources

  def index
    @current_sub_tab = 'Browse Resources'
    @resources = Resource.top
  end

  def new
    @current_sub_tab = 'Suggest Resource'
    @resource = Resource.new
    @resources = Resource.newest
  end

  def create
    @resource = Resource.new(params[:resource])
    @resource.user = current_user
    @resource.tag_list = params[:resource][:tags_string]

    if @resource.save
      #JR - can I swap in t('string') here in controller
    	flash[:success] = "Thank you for adding to our directory!"
    	redirect_to resource_path(@resource)
    else
      @resources = Resource.newest
    	render :new
    end
  end

  def show
    @resource = Resource.find(params[:id])
    tag_cloud @resource
  end

  def my_resources
    @current_sub_tab = 'My Resources'
    @user = User.find(params[:id])
    @resources = @user.resources
  end

  def like
    @resource = Resource.find_by_id(params[:id])
    respond_to do |format|
      if current_user and @resource.present? and current_user.vote_for(@resource)
      	success = "Thanks for your vote!"
      	format.html { flash[:success] = success; redirect_to params[:return_to] || resources_path }
      	format.fbml { flash[:success] = success; redirect_to params[:return_to] || resources_path }
      	format.json { render :json => { :msg => "#{@resource.votes.size} likes" }.to_json }
      	format.fbjs { render :json => { :msg => "#{@resource.votes.size} likes" }.to_json }
      else
      	error = "Vote failed"
      	format.html { flash[:error] = error; redirect_to params[:return_to] || resources_path }
      	format.fbml { flash[:error] = error; redirect_to params[:return_to] || resources_path }
      	format.json { render :json => { :msg => error }.to_json }
      	format.fbjs { render :text => { :msg => error }.to_json }
      end
    end
  end

  private

  def set_current_tab
    @current_tab = 'resources'
  end

end
