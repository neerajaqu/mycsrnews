# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

APPLICATION_CONFIGURATION_FILE_LOCATION = "#{RAILS_ROOT}/config/application_settings.yml"
APP_CONFIG = YAML.load_file(APPLICATION_CONFIGURATION_FILE_LOCATION)[RAILS_ENV]
ActionMailer::Base.default_url_options[:host] = APP_CONFIG['base_url'].sub(/^https?:\/\//,'')

Time.zone = APP_CONFIG['time_zone'] || 'Pacific Time (US & Canada)'