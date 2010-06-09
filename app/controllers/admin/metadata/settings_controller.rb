class Admin::Metadata::SettingsController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::Setting.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata::Setting,
    	:fields => [:setting_name, :setting_sub_type_name, :setting_value],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @setting = Metadata::Setting.find(params[:id])

    render_edit @setting
  end

  def update
    @setting = Metadata::Setting.find(params[:id])
    #@setting.data = params[:custom_data].symbolize_keys
    if @setting.update_attributes(params[:metadata_setting])
      flash[:success] = "Successfully updated your setting."
      redirect_to admin_metadata_setting_path(@setting)
    else
      flash[:error] = "Could not update your setting as requested. Please try again."
      render_edit @setting
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::Setting.find(params[:id]),
      :model => Metadata::Setting,
    	:fields => [:setting_name, :setting_sub_type_name, :setting_value, :created_at],
    }
  end

  def create
    @setting = Metadata::Setting.new(params[:metadata_setting])
    if @setting.save
      flash[:success] = "Successfully created your setting."
      redirect_to admin_metadata_setting_path(@setting)
    else
      flash[:error] = "Could not create your setting as requested. Please try again."
      render_new @setting
    end
  end

  def destroy
    @setting = Metadata::Setting.find(params[:id])
    @setting.destroy

    redirect_to admin_metadata_settings_path
  end

  private

  def render_new setting = nil
    setting ||= Metadata::Setting.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => setting,
    	:model => Metadata::Setting,
    	:fields => [:setting_name, lambda {|f| f.input :setting_sub_type_name, :required => false }, :setting_value]
    }
  end

  def render_edit setting
    setting ||= Metadata::Setting.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => setting,
    	:model => Metadata::Setting,
    	:fields => [:setting_name, lambda {|f| f.input :setting_sub_type_name, :required => false }, :setting_value]
    }
  end

  def set_current_tab
    @current_tab = 'settings';
  end

end
