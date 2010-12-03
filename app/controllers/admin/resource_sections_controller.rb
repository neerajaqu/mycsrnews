class Admin::ResourceSectionsController < AdminController

  cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  def index
    @resource_sections = ResourceSection.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @resource_section = ResourceSection.new
  end

  def edit
    @resource_section = ResourceSection.find(params[:id])
  end

  def update
    @resource_section = ResourceSection.find(params[:id])
    if @resource_section.update_attributes(params[:resource_section])
      flash[:success] = "Successfully updated your Resource Section."
      redirect_to [:admin, @resource_section]
    else
      flash[:error] = "Could not update your Resource Section as requested. Please try again."
      render :edit
    end
  end

  def show
    @resource_section = ResourceSection.find(params[:id])
  end

  def create
    @resource_section = ResourceSection.new(params[:resource_section])
    if @resource_section.save
      flash[:success] = "Successfully created your new Resource Section!"
      redirect_to [:admin, @resource_section]
    else
      flash[:error] = "Could not create your Resource Section, please try again"
      render :new
    end
  end

  def destroy
    @resource_section = ResourceSection.find(params[:id])
    @resource_section.destroy
    redirect_to admin_resource_sections_path
  end

  private

  def set_current_tab
    @current_tab = 'resource-sections';
  end

end
