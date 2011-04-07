class Admin::SettingGroupsController < AdminController
  before_filter :find_locale

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
      params[:setting_group] and params[:setting_group].each do |setting_name, value|
        key,type = setting_name.split(/--/)
        setting = Metadata::Setting.get_setting(key, type)
        setting.update_value! nil unless setting.value == value
      end
      params[:translation_group] and params[:translation_group].each do |translation_key, value|
        translation = @locale.translations.find_by_raw_key(translation_key)
        translation.update_attribute(:value, value) unless translation.value == value
      end
    end
    redirect_to admin_setting_groups_path
  end

  private

    def set_current_tab
      @current_tab = 'setting_groups';
    end

    def find_locale
      @locale = Locale.find_by_code(params[:locale])
    end

end
