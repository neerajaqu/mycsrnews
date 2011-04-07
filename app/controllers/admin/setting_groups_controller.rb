class Admin::SettingGroupsController < AdminController

  def index
    @setting_groups = Newscloud::SettingGroups.groups
  end

  def show
    @setting_group = Newscloud::SettingGroups.group params[:id].to_sym
  end

  def edit
    @setting_group_name = params[:id]
    @setting_group = Newscloud::SettingGroups.group params[:id].to_sym
  end

  def update
    @setting_group = Newscloud::SettingGroups.group params[:id].to_sym
    ActiveRecord::Base.transaction do
      params[:setting_group].each do |setting_name, value|
        key,type = setting_name.split(/--/)
        setting = Metadata::Setting.get_setting(key, type)
        setting.update_value! value unless setting.value == value
      end
    end
    redirect_to admin_setting_groups_path
  end

  private

  def set_current_tab
    @current_tab = 'setting_groups';
  end

end
