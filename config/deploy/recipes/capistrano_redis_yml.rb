# 
# = Capistrano resque.yml task
#
# Provides a couple of tasks for creating the resque.yml 
# configuration file dynamically when deploy:setup is run.
#
# Category::    Capistrano
# Package::     Database
# Author::      Simone Carletti <weppos@weppos.net>
# Copyright::   2007-2010 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :redis do

      desc <<-DESC
        Creates the resque.yml configuration file in shared path.
      DESC
      task :setup, :except => { :no_release => true } do
        deploy.redis.setup_primary_config
        deploy.redis.setup_worker_config
      end

      task :setup_primary_config, :roles => :app, :except => { :no_release => true } do
        set :redis_host, nil

        location = fetch(:template_dir, "config/deploy/templates") + '/resque.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/resque.yml"
      end

      task :setup_worker_config, :roles => :workers, :except => { :no_release => true } do
        next if find_servers_for_task(current_task).empty?
        location = fetch(:template_dir, "config/deploy/templates") + '/resque.yml.erb'
        template = File.read(location)

        set :redis_host, fetch(:primary_redis_host, base_url)
        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/resque.yml"
      end

      desc <<-DESC
        [internal] Updates the symlink for resque.yml file to the just deployed release.
      DESC
      task :symlink, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/resque.yml #{release_path}/config/resque.yml" 
      end

      desc <<-DESC
        Test file write
      DESC
      task :test_write, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/resque.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
        File.open("tmp/test_resque.yml", "w") {|f| f.write config.result(binding) }
      end

    end

    after "deploy:setup",           "deploy:redis:setup"   unless fetch(:skip_redis_setup, false)
    after "deploy:finalize_update", "deploy:redis:symlink"

  end

end
