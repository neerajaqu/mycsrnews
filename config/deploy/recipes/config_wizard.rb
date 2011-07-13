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
      @display_welcome = true
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

  namespace :newscloud do

    desc <<-DESC
      Run the full newscloud bootstrap script.
    DESC
    task :run do
      run_color_scheme
      say_headline('Welcome to the Newscloud bootstrap script. This will take care of provisioning your ubuntu server and bootstrapping the Newscloud framework.')
      say_headline("\nBase config settings")
      @enable_advanced_config = Capistrano::CLI.ui.agree("Advanced config mode?") {|q| q.default = "no" }
      @using_aws = Capistrano::CLI.ui.agree("Deploying to Amazon AWS?") {|q| q.default = "no" }
      settings = {}
      settings[:using_aws] = @using_aws
      settings[:app_name] = get_app
      settings[:default_user] = ui.ask("Please enter the ssh username for your server:") do |q|
        q.default = @using_aws ? "ubuntu" : "root"
        q.validate = /^[A-Za-z_-]+$/
        q.responses[:not_valid] = "Please use only letters, underscores and dashes"
      end
      if @using_aws
        settings[:aws_key_location] = ui.ask("Please enter the path to your AWS private key so that you can deploy to your server:") do |q|
          q.validate = /^.+$/
        end
      end

      if @enable_advanced_config
        settings[:default_mysql_root_password] = ui.ask("Please enter the mysql root password you would like to use:") do |q|
          q.default = "root"
          q.validate = /^.+$/
        end
      else
        settings[:default_mysql_root_password] = "root"
      end

      settings = run_wizard settings

      save_settings settings
      cap_set_stage settings[:app_name]

      say_headline("\nRunning full system bootstrap. This will take a while and does not require any user intervention after logging into your server, so grab a cup of coffee.\n")
      say_headline("\nInitializing server..\n")
      # Set user to the provided user account on the server for ssh access
      set :user, settings[:default_user]
      chef.init_server
      # Now that we've initialized the user, we have a deploy user to work with
      close_sessions
      set :user, 'deploy'
      say_headline("\nBootstrapping server with chef..\n")
      chef.bootstrap
      say_headline("\nSetting up rails directory structure..\n")
      deploy.setup
      say_headline("\nBootstrapping newscloud rails framework..\n")
      deploy.cold
      say_headline("\nCongragulations, your server #{settings[:app_name]}(#{settings[:base_url]}) is up and running!!\n")
    end

  end

  # TODO:: switch this back to set_stage at bottom
  def cap_set_stage stage_name
    unless stages.map(&:to_s).include? stage_name
      puts "Defining task: #{stage_name}"
      desc "Set the target stage to `#{stage_name}'."
      task(stage_name) do
        set :stage, stage_name.to_sym
        load "config/deploy/#{stage_name}.rb"
      end 
    end
    roles.clear
    stages.push stage_name
    full_stage_name = search_task(stage_name).fully_qualified_name
    find_and_execute_task full_stage_name
  end

end

def ui
  @ui ||= Capistrano::CLI.ui
end

def run_wizard settings = {}
  run_color_scheme
  say_headline('Welcome to the Newscloud configuration wizard') if @display_welcome
  settings ||= {}
  settings[:app_name] ||= stage.to_s == default_stage.to_s ? get_app : stage
  settings[:facebooker] = get_facebook_config
  if @enable_advanced_config and Capistrano::CLI.ui.agree("Use separate worker server") {|q| q.default = "no" }
    settings[:worker_server] = get_worker_server if @enable_advanced_config
  end
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

def get_worker_server
  ui.ask("Please enter your worker server address") do |q|
    q.case = :down
    q.validate = lambda do |url|
      # TODO:: add validation for aws urls
      #url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(\/.*)?$/ or url =~ /^(http|https):\/\/([0-9]{1,3}){4}$/
      true
    end
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
      # TODO:: add back in
      #return false unless url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(\/.*)?$/
      return false if url =~ /iframe\/?$/
      true
    end
    q.responses[:not_valid] = "Facebook Callback URL should look like a url and cannot end in 'iframe'."
  end


  return settings
end

def get_database_config app_name
  unless @enable_advanced_config
    return {
      :name => "#{app_name}_production",
      :user => "#{app_name}_db_user"[0,16],
      :password => newpass
    }
  end

  say_headline("Database Configuration")
  settings = Hash.new

  settings[:name] = ui.ask("Please enter the name of the production database you will use:") do |q|
    q.default = "#{app_name}_production"
    q.validate = /^.+$/
  end
  settings[:user] = non_blank_request("Database User Name (Max 16 chars)", :default => "#{app_name}_db_user"[0,16])

=begin
  # NOTE:: Can't do this anymore, _must_ have db password to generate database with chef
  #
  # old deploy.rb.erb password line
  # set :db_password, <%= @settings[:database][:password] ? "\"#{@settings[:database][:password]}\"" : 'nil' %>
  #
  settings[:password] = ui.ask("Please enter the database password (Leave blank to be prompted for your password on deploy)", lambda {|str| str.empty? ? nil : str }) do |q|
    q.echo = "*"
    #q.validate = /^.+$/
  end
=end
  settings[:password] = ui.ask("Please enter the database password") do |q|
    q.echo = "*"
    q.default = newpass
    q.validate = /^.+$/
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
  save_dna_json_file settings, prefix
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
  @settings = settings
  File.open("config/deploy/#{filename}", "w") {|f| f.write deploy_template.result(binding) }
end

def save_dna_json_file settings, prefix = nil
  # TODO:: update this to actually perform a check on multiserver
  settings[:mysql_bind_address] = false ? "127.0.0.1" : "0.0.0.0"
  settings[:redis_bind_address] = false ? "127.0.0.1" : "0.0.0.0"
  filename = "#{prefix}#{settings[:app_name]}_dna.json"
  worker_filename = "#{prefix}#{settings[:app_name]}_worker_dna.json"

  location = fetch(:template_dir, "config/deploy/templates") + "/dna.json.erb"
  worker_location = fetch(:template_dir, "config/deploy/templates") + "/dna_worker.json.erb"
  template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")
  worker_template = File.file?(worker_location) ? File.read(worker_location) : raise("File Not Found: #{worker_location}")
  dna_json_template = ERB.new(template)
  worker_dna_json_template = ERB.new(worker_template)
  @settings = settings
  File.open("config/deploy/#{filename}", "w") {|f| f.write dna_json_template.result(binding) }
  File.open("config/deploy/#{worker_filename}", "w") {|f| f.write worker_dna_json_template.result(binding) }
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

def set_stage stage_name
  unless stages.map(&:to_s).include? stage_name
    puts "Defining task: #{stage_name}"
    desc "Set the target stage to `#{stage_name}'."
    task(stage_name) do
      set :stage, stage_name.to_sym
      load "config/deploy/#{stage_name}.rb"
    end 
  end
  roles.clear
  stages.push stage_name
  full_stage_name = search_task(stage_name).fully_qualified_name
  find_and_execute_task full_stage_name
end

# Random password generator
# Thanks to: http://snippets.dzone.com/posts/show/491
def newpass(len=10 )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
end
