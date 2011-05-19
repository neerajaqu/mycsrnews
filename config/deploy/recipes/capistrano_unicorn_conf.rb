# = Capistrano unicorn.conf.rb task
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
        Creates the unicorn.conf.rb configuration file in shared path.

        When this recipe is loaded, config:unicorn_conf_setup is automatically configured \
        to be invoked after deploy:setup. You can skip this task setting \
        the variable :skip_unicorn_conf_setup to true. This is especially useful \ 
        if you are using this recipe in combination with \
        capistrano-ext/multistaging to avoid multiple config:setup_unicorn_conf calls \ 
        when running deploy:setup for all stages one by one.
      DESC
      task :setup_unicorn_conf, :except => { :no_release => true } do

        location = fetch(:template_dir, "config/deploy/templates") + '/unicorn.conf.rb.erb'
        template = File.file?(location) ? File.read(location) : raise("File Not Found: #{location}")

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/unicorn.conf.rb"
      end

      desc <<-DESC
        [internal] Updates the symlink for unicorn.conf.rb file to the just deployed release.
      DESC
      task :symlink_unicorn_conf, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/unicorn.conf.rb #{release_path}/config/unicorn.conf.rb" 
      end

      desc <<-DESC
        Test file write
      DESC
      task :test_unicorn_conf_write, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/unicorn.conf.rb.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
        File.open("tmp/test_unicorn.conf.rb", "w") {|f| f.write config.result(binding) }
      end

    end

    after "deploy:setup",           "deploy:config:setup_unicorn_conf"   unless fetch(:skip_unicorn_conf_setup, false)
    after "deploy:finalize_update", "deploy:config:symlink_unicorn_conf"

  end

end
