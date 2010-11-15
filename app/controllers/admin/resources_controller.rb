class Admin::ResourcesController < AdminController

  cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  def index
    @resources = Resource.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @resource = Resource.new
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      flash[:success] = "Successfully updated your Resource ."
      redirect_to [:admin, @resource]
    else
      flash[:error] = "Could not update your Resource  as requested. Please try again."
      render :edit
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def create
    @resource = Resource.new(params[:resource])
    @resource.user = current_user
    if @resource.save
      flash[:success] = "Successfully created your new Resource !"
      redirect_to [:admin, @resource]
    else
      flash[:error] = "Could not create your Resource , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'resources';
  end

end
