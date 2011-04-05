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
    @settings = params[:setting_group].map do |setting, value|
      key,type = setting.split(/--/)
      [Metadata::Setting.get_setting(key, type), value]
    end
    raise @settings.inspect
  end

  private

  def set_current_tab
    @current_tab = 'setting_groups';
  end

end
