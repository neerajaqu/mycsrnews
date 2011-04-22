# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

menu_file = "#{RAILS_ROOT}/config/menu.yml"
menu_file_location = File.exist?(menu_file) ? menu_file : (menu_file + '.sample')
MENU = YAML.load_file(menu_file_location)["menu"]
