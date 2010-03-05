# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

MENU = YAML.load_file("#{RAILS_ROOT}/config/menu.yml")["menu"]
