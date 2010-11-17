class Admin::Metadata::SettingsController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::Setting.paginate(:page => params[:page], :per_page => 30, :order => "key_sub_type asc, key_name asc"),
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
      # sweep cache elements when specific settings change
      if @setting.key_name.include? "welcome_"
        WidgetSweeper.expire_item "welcome_panel"
      end
      if @setting.key_name.include? "google_search_engine_id"
        WidgetSweeper.expire_item "google_search"
      end
      if @setting.key_name.include? "widget_stories_short_max"
        WidgetSweeper.expire_item "stories_short"
      end
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
    	:fields => [:setting_name, :setting_sub_type_name, :setting_value, :setting_hint, :created_at],
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
    	:fields => [:setting_name, :setting_hint, lambda {|f| f.input :setting_sub_type_name, :required => false }, :setting_value]
    }
  end

  def render_edit setting
    setting ||= Metadata::Setting.new
=begin
    if setting.name == 'site_notification_user'
      render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      	:item => setting,
      	:model => Metadata::Setting,
      	:fields => [:setting_name, :setting_hint, lambda {|f| f.input :setting_sub_type_name, :required => false }, lambda {|f| f.input :setting_value, :as => :select, :collection => User.admins, :hint => :setting_hint } ]
      }
    else  
    end
=end
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => setting,
    	:model => Metadata::Setting,
    	:fields => [:setting_name, :setting_hint, lambda {|f| f.input :setting_sub_type_name, :required => false }, lambda {|f| f.input :setting_value, :hint => :setting_hint } ]
    }
  end

  def set_current_tab
    @current_tab = 'settings';
  end

end
