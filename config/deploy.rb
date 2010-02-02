set :default_stage, "chewbranca_staging"
set :stages, %w(n2_production n2_staging chewbranca_staging)
require 'capistrano/ext/multistage'

default_run_options[:pty] = true

set :repository,  "git@github.com:newscloud/N2.git"
set :scm, :git
set :deploy_via, :remote_cache

set (:deploy_to) { "/data/#{application}" }

#set :user, 'deploy' # uncomment this or set in your specific multistage file
set :use_sudo, false

task :after_update_code do
  # setup shared files
  %w{/config/unicorn.conf.rb /tmp/sockets /config/database.yml
    /config/facebooker.yml /config/application_settings.yml
    /config/application.god}.each do |file|
      run "ln -nfs #{shared_path}#{file} #{release_path}#{file}"
  end

  deploy.cleanup
end

task :before_deploy do
  deploy.god.stop
end

task :after_deploy do
  deploy.god.start
end

namespace :deploy do
  
  namespace :god do
    desc "Start God monitoring"
    task :stop, :roles => :app, :on_error => :continue do
      sudo 'god quit'
    end

    desc "Stop God monitoring"
    task :start, :roles => :app do
      sudo "god -c #{current_path}/config/application.god"
    end
  end

  desc "Restart application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cat #{current_path}/tmp/pids/unicorn.pid | xargs kill -USR2"
  end

  desc "Start application"
  task :start, :roles => :app do
    run "cd #{current_path} && /usr/bin/unicorn_rails -c #{current_path}/config/unicorn.conf.rb -E #{rails_env} -D"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "cat #{current_path}/tmp/pids/unicorn.pid | xargs kill -QUIT"
  end
end
