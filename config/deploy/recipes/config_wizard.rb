require 'yaml'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :config do


    desc <<-DESC
      Newscloud Config Wizard
    DESC
    task :wizard do
      settings = run_wizard
      ui.say("Successfully configured #{settings[:app_name]}")
    end

    desc <<-DESC
      Fetch remote config, used to rebuild your yaml config files.
    DESC
    task :fetch_remote do
      settings = extract_settings get_remote_config
      settings[:app_name] = stage.to_s
      settings[:branch] = 'master'

      save_settings settings
    end
  end
end

def ui
  @ui ||= Capistrano::CLI.ui
end

def run_wizard
  run_color_scheme
  say_headline('Welcome to the newscloud configuration wizard')
  settings = Hash.new
  settings[:app_name] = stage.to_s == default_stage.to_s ? get_app : stage
  settings[:facebooker] = get_facebook_config
  settings[:database] = get_database_config settings[:app_name]
  settings[:base_url] ||= settings[:facebooker][:callback_url].sub(%r{^https?://}, '')
  save_settings settings

  return settings
end

def run_color_scheme
  HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
    cs[:headline]        = [ :bold, :yellow, :on_black ]
    cs[:horizontal_line] = [ :bold, :white, :on_blue]
    cs[:even_row]        = [ :green ]
    cs[:odd_row]         = [ :magenta ]
  end
end

def get_app
  ui.ask("Please enter your application name (lowercase and underscore):") do |q|
    q.case = :down
    q.validate = /^[a-z0-9_]+$/
  end
end

def get_facebook_config
  say_headline("Facebook Configuration")
  settings = Hash.new

  settings[:api_key] = non_blank_request("Facebook API Key:")
  settings[:secret_key] = non_blank_request("Facebook Secret Key:")

  settings[:canvas_page_name] = ui.ask("Please enter your Facebook Canvas Page Name:") do |q|
    q.case = :down
    q.validate = /^[a-z_-]+$/
    q.responses[:not_valid] = "Facebook Canvas Page Name can only contain lower case letters, dashes, and underscores."
  end

  settings[:callback_url] = ui.ask("Please enter your Facebook Callback URL:", lambda {|str| str.sub(%r{/$}, '')} ) do |q|
    q.case = :down
    q.validate = lambda do |url|
      return false unless url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(\/.*)?$/
      return false if url =~ /iframe\/?$/
      true
    end
    q.responses[:not_valid] = "Facebook Callback URL should look like a url and cannot end in 'iframe'."
  end


  return settings
end

def get_database_config app_name
  say_headline("Database Configuration")
  settings = Hash.new

  settings[:name] = ui.ask("Please enter the name of the production database you will use:") do |q|
    q.default = "#{app_name}_production"
    q.validate = /^.+$/
  end
  settings[:user] = non_blank_request("Database User Name (Max 16 chars)", :default => "#{app_name}_db_user"[0,16])
  settings[:password] = ui.ask("Please enter the database password (Leave blank to be prompted for your password on deploy)", lambda {|str| str.empty? ? nil : str }) do |q|
    q.echo = "*"
    #q.validate = /^.+$/
  end

  return settings
end

def get_remote_config
  config = {}
  config["database"] = YAML.load(read_remote_file("#{shared_path}/config/database.yml"))[rails_env]
  config["facebooker"] = YAML.load(read_remote_file("#{shared_path}/config/facebooker.yml"))[rails_env]
  config["newrelic"] = YAML.load(read_remote_file("#{shared_path}/config/newrelic.yml"))
  config["smtp"] = YAML.load(read_remote_file("#{shared_path}/config/smtp.yml"))[rails_env]
  config["app"] = YAML.load(read_remote_file("#{shared_path}/config/application_settings.yml"))[rails_env]
  config
end

def non_blank_request(key_name, opts = {})
  ui.ask("Please enter your #{key_name}") do |q|
    q.validate = /^\w+$/
    q.responses[:not_valid] = "You must provide a #{key_name}"
    q.default = opts[:default] if opts[:default]
  end
end

def say_headline(*args, &block)
  ui.say("<%= color('\n#{args.shift}', :headline) %>", *args, &block)
  ui.say("<%= color('-'*20, :horizontal_line) %>")
end

def save_settings settings, prefix = nil
  save_yaml_file settings, prefix
  save_deploy_file settings, prefix
end

def save_yaml_file settings, prefix = nil
  filename = "#{prefix}#{settings[:app_name]}_settings.yml"
  File.open("config/deploy/#{filename}", "w") {|f| YAML.dump(settings, f) }
end

def save_deploy_file settings, prefix = nil
  filename = "#{prefix}#{settings[:app_name]}.rb"

  location = fetch(:template_dir, "config/deploy/templates") + "/deploy.rb.erb"
  template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")
  deploy_template = ERB.new(template)
  # TODO:: remove _test
  #settings ||= settings
  @settings = settings
  File.open("config/deploy/#{filename}", "w") {|f| f.write deploy_template.result(binding) }
end

def extract_settings config
  {
    :base_url   => config["facebooker"]["callback_url"].sub(%r{^https?://}, ''),
    :app_name   => stage.to_s,
    :facebooker => {
      :canvas_page_name => config["facebooker"]["canvas_page_name"],
      :callback_url     => config["facebooker"]["callback_url"],
      :api_key          => config["facebooker"]["api_key"],
      :secret_key       => config["facebooker"]["secret_key"]
    },
    :database   => {
      :user     => config["database"]["username"],
      :name     => config["database"]["database"],
      :password => config["database"]["password"],
    },
    :newrelic   => {
      :license_key => config["newrelic"]["common"]["license_key"]
    },
    :smtp       => {
      :enable_starttls_auto => config["smtp"]["enable_starttls_auto"],
      :address              => config["smtp"]["address"],
      :port                 => config["smtp"]["port"],
      :domain               => config["smtp"]["domain"],
      :authentication       => config["smtp"]["authentication"],
      :user_name            => config["smtp"]["user_name"],
      :password             => config["smtp"]["password"]
    }
  }
end
