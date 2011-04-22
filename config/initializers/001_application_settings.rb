# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

app_settings_file = "#{RAILS_ROOT}/config/application_settings.yml"

APPLICATION_CONFIGURATION_FILE_LOCATION = File.exist?(app_settings_file) ? app_settings_file : (app_settings_file + '.sample')
APP_CONFIG = YAML.load_file(APPLICATION_CONFIGURATION_FILE_LOCATION)[RAILS_ENV]
APP_CONFIG['base_site_url'] = FACEBOOKER['callback_url']
APP_CONFIG['use_view_objects'] = true unless APP_CONFIG.keys.include? "use_view_objects"
ActionMailer::Base.default_url_options[:host] = APP_CONFIG['base_site_url'].sub(/^https?:\/\//,'')

Time.zone = APP_CONFIG['time_zone'] || 'Pacific Time (US & Canada)'