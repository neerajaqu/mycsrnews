class Admin::SettingsController < AdminController
  skip_before_filter :admin_user_required

  def index
    @settings = Metadata.meta_type('config')
  end

  def new
    @metadata = Metadata.new
  end

  def edit
    @metadata = Metadata.find(params[:id])
  end

  def update
    @metadata = Metadata.find(params[:id])
    @metadata.data = params[:custom_data].symbolize_keys
    if @metadata.update_attributes(params[:metadata])
      flash[:success] = "Successfully updated your Custom Widget."
      redirect_to admin_setting_path(@metadata)
    else
      flash[:error] = "Could not update your Custom Widget as requested. Please try again."
      render :edit
    end
  end

  def show
    @metadata = Metadata.find(params[:id])
  end

  def create
  end

  def destroy
    @metadata = Metadata.find(params[:id])
    @metadata.destroy

    redirect_to admin_settings_path
  end

  private

  def set_current_tab
    @current_tab = 'settings';
  end

end
