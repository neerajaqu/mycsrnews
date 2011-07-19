# = Capistrano application.god task
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
        Creates the application.god configuration file in shared path.

        When this recipe is loaded, config:application_god_setup is automatically configured \
        to be invoked after deploy:setup. You can skip this task setting \
        the variable :skip_application_god_setup to true. This is especially useful \ 
        if you are using this recipe in combination with \
        capistrano-ext/multistaging to avoid multiple config:setup_application_god calls \ 
        when running deploy:setup for all stages one by one.
      DESC
      task :setup_application_god, :except => { :no_release => true } do
        deploy.config.setup_application_god_primary
        deploy.config.setup_application_god_workers
      end

      task :setup_application_god_primary, :roles => :app, :except => { :no_release => true } do

        set :enable_god_for_app, true
        set(:enable_god_for_workers) { roles[:workers].empty? or roles[:workers].include?(find_servers_for_task(current_task).first) }
        location = fetch(:template_dir, "config/deploy/templates") + '/application.god.erb'
        template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/application.god"
      end

      task :setup_application_god_workers, :roles => :workers, :except => { :no_release => true } do
        next if find_servers_for_task(current_task).empty?
        set :enable_god_for_app, false
        set :enable_god_for_workers, true

        location = fetch(:template_dir, "config/deploy/templates") + '/application.god.erb'
        template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/application.god"
      end

      desc <<-DESC
        [internal] Updates the symlink for application.god file to the just deployed release.
      DESC
      task :symlink_application_god, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/application.god #{release_path}/config/application.god" 
      end

      desc <<-DESC
        Test file write
      DESC
      task :test_application_god_write, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/application.god.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
        File.open("tmp/test_application.god", "w") {|f| f.write config.result(binding) }
      end

    end

    after "deploy:setup",           "deploy:config:setup_application_god"   unless fetch(:skip_application_god_setup, false)
    after "deploy:finalize_update", "deploy:config:symlink_application_god"

  end

end
