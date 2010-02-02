# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/application_settings.yml")[RAILS_ENV]
