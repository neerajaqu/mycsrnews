# = Capistrano facebooker.yml task
# 
# Forked from::
# = Capistrano database.yml task
#
# Provides a couple of tasks for creating the database.yml 
# configuration file dynamically when deploy:setup is run.
#
# Category::    Capistrano
# Package::     Database
# Author::      Simone Carletti <weppos@weppos.net>
# Copyright::   2007-2010 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
#

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :config do

      desc <<-DESC
        Creates the facebooker.yml configuration file in shared path.

        By default, this task uses a template unless a template \
        called facebooker.yml.erb is found either is :template_dir \
        or /config/deploy/templates folders. The default template matches \
        the template for config/facebooker.yml file shipped with the facebooker gem.

        When this recipe is loaded, config:facebooker_setup is automatically configured \
        to be invoked after deploy:setup. You can skip this task setting \
        the variable :skip_facebooker_setup to true. This is especially useful \ 
        if you are using this recipe in combination with \
        capistrano-ext/multistaging to avoid multiple config:setup_facebooker calls \ 
        when running deploy:setup for all stages one by one.
      DESC
      task :setup_facebooker, :except => { :no_release => true } do

        default_template = <<-EOF
        development:
          api_key:
          secret_key:
          canvas_page_name:
          callback_url:
          pretty_errors: true
          set_asset_host_to_callback_url: true
          tunnel:
            public_host_username:
            public_host:
            public_port: 4007
            local_port: 3000
            server_alive_interval: 0

        test:
          api_key:
          secret_key:
          canvas_page_name:
          callback_url:
          set_asset_host_to_callback_url: true
          tunnel:
            public_host_username:
            public_host:
            public_port: 4007
            local_port: 3000
            server_alive_interval: 0

        production:
          api_key:
          secret_key:
          canvas_page_name:
          callback_url:
          set_asset_host_to_callback_url: true
          tunnel:
            public_host_username:
            public_host:
            public_port: 4007
            local_port: 3000
            server_alive_interval: 0
        EOF

        location = fetch(:template_dir, "config/deploy/templates") + '/facebooker.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/facebooker.yml"
      end

      desc <<-DESC
        [internal] Updates the symlink for facebooker.yml file to the just deployed release.
      DESC
      task :symlink_facebooker, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/facebooker.yml #{release_path}/config/facebooker.yml" 
      end

      desc <<-DESC
        Test file write
      DESC
      task :test_facebooker_write, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/facebooker.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
        File.open("tmp/test_facebooker.yml", "w") {|f| f.write config.result(binding) }
      end

    end

    after "deploy:setup",           "deploy:config:setup_facebooker"   unless fetch(:skip_facebooker_setup, false)
    after "deploy:finalize_update", "deploy:config:symlink_facebooker"

  end

end
