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
      HighLine.color_scheme = HighLine::ColorScheme.new do |cs|
        cs[:headline]        = [ :bold, :yellow, :on_black ]
        cs[:horizontal_line] = [ :bold, :white, :on_blue]
        cs[:even_row]        = [ :green ]
        cs[:odd_row]         = [ :magenta ]
      end
 
      @ui = Capistrano::CLI.ui
      @settings = Hash.new
      @app_name = stage.to_s == default_stage.to_s ? get_app : stage
      @settings[:app_name] = @app_name

      run_wizard
      #@ui.say("Responses for #{@app_name}")
      #@ui.say("#{@settings.inspect}")
      @ui.say("Successfully configured #{@app_name}")
    end
  end
end

def run_wizard
  say_headline('Welcome to the newscloud configuration wizard')
  @ui.say("Default/Current stage #{default_stage}/#{defined?(stage) ? stage : "undefined"}")
  get_app unless @app_name
  get_facebook_config
  get_database_config
  save_settings
end

def get_app
  @ui.ask("Please enter your application name (lowercase and underscore):") do |q|
    q.case = :down
    q.validate = /^[a-z0-9_]+$/
  end
end

def get_facebook_config
  say_headline("Facebook Configuration")
  @settings[:facebooker] ||= Hash.new

  @settings[:facebooker][:api_key] = non_blank_request("Facebook API Key:")
  @settings[:facebooker][:secret_key] = non_blank_request("Facebook Secret Key:")

  @settings[:facebooker][:canvas_page_name] = @ui.ask("Please enter your Facebook Canvas Page Name:") do |q|
    q.case = :down
    q.validate = /^[a-z_-]+$/
    q.responses[:not_valid] = "Facebook Canvas Page Name can only contain lower case letters, dashes, and underscores."
  end

  @settings[:facebooker][:callback_url] = @ui.ask("Please enter your Facebook Callback URL:", lambda {|str| str.sub(%r{/$}, '')} ) do |q|
    q.case = :down
    q.validate = lambda do |url|
      return false unless url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(\/.*)?$/
      return false if url =~ /iframe\/?$/
      true
    end
    q.responses[:not_valid] = "Facebook Callback URL should look like a url and cannot end in 'iframe'."
  end

  @settings[:base_url] ||= @settings[:facebooker][:callback_url].sub(%r{^https?://}, '')
end

def get_database_config
  say_headline("Database Configuration")
  @settings[:database] ||= Hash.new

  @settings[:database][:name] = @ui.ask("Please enter the name of the production database you will use:") do |q|
    q.default = "#{@app_name}_production"
    q.validate = /^.+$/
  end
  @settings[:database][:user] = non_blank_request("Database User Name (Max 16 chars)", :default => "#{@app_name}_db_user"[0,16])
  @settings[:database][:password] = @ui.ask("Please enter the database password (Leave blank to be prompted for your password on deploy)", lambda {|str| str.empty? ? nil : str }) do |q|
    q.echo = "*"
    #q.validate = /^.+$/
  end
end

def non_blank_request(key_name, opts = {})
  @ui.ask("Please enter your #{key_name}") do |q|
    q.validate = /^\w+$/
    q.responses[:not_valid] = "You must provide a #{key_name}"
    q.default = opts[:default] if opts[:default]
  end
end

def say_headline(*args, &block)
  @ui.say("<%= color('\n#{args.shift}', :headline) %>", *args, &block)
  @ui.say("<%= color('-'*20, :horizontal_line) %>")
end

def save_settings
  save_yaml_file
  save_deploy_file
end

def save_yaml_file
  File.open("config/deploy/#{@app_name}_settings.yml", "w") {|f| YAML.dump(@settings, f) }
end

def save_deploy_file
  location = fetch(:template_dir, "config/deploy/templates") + "/deploy.rb.erb"
  template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")
  deploy_template = ERB.new(template)
  # TODO:: remove _test
  File.open("config/deploy/#{@app_name}.rb", "w") {|f| f.write deploy_template.result(binding) }
end
