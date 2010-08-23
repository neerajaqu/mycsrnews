set :default_stage, "n2_staging"
set (:stages) { Dir.glob(File.join(File.dirname(__FILE__), "deploy", "*.rb")).map {|s| File.basename(s, ".rb") }.select {|s| not s =~ /sample/} }
require 'capistrano/ext/multistage'
require 'eycap/recipes'

default_run_options[:pty] = true

set :repository,  "git://github.com/newscloud/n2.git"
set :scm, :git
set :deploy_via, :remote_cache

set (:deploy_to) { "/data/sites/#{application}" }

set :user, 'deploy'
set :use_sudo, false

after("deploy:update_code") do
  # setup shared files
  %w{/config/unicorn.conf.rb /tmp/sockets /config/database.yml
    /config/facebooker.yml /config/application_settings.yml
    /config/application.god /config/newrelic.yml
    /config/smtp.yml /config/menu.yml /config/compass.rb /config/resque.yml}.each do |file|
      run "ln -nfs #{shared_path}#{file} #{release_path}#{file}"
  end

  deploy.load_skin
  deploy.restore_previous_sitemap
  deploy.cleanup
end

before("deploy") do
  deploy.god.stop
end

before("deploy:stop") do
  deploy.god.stop
end

before("deploy:migrations") do
  deploy.god.stop
end

after("deploy") do
  run "cd #{current_path} && rake n2:queue:restart_workers"
  run "cd #{current_path} && rake n2:queue:restart_scheduler APP_NAME=#{application}"
  deploy.god.start
  newrelic.notice_deployment
end

after("deploy:migrations") do
  run "cd #{current_path} && rake n2:queue:restart_workers"
  run "cd #{current_path} && rake n2:queue:restart_scheduler APP_NAME=#{application}"
  deploy.god.start
  newrelic.notice_deployment
end

before "deploy:start" do
  set :rake_post_path, release_path
  deploy.rake_post_deploy
end

before "deploy:restart" do
  set :rake_post_path, current_path
  deploy.rake_post_deploy
end

before("deploy:web:disable") do
  deploy.god.stop
end

after("deploy:web:enable") do
  deploy.god.start
end

after("deploy:setup") do
  if stage.to_s[0,3] == "n2_"
  	puts "Setting up default config files"
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/tmp/sockets"
    run "cp /data/defaults/config/* #{shared_path}/config/"
  end
end

after("deploy:cold_bootstrap") do
  deploy.god.start
end

namespace :deploy do
  
  namespace :god do
    desc "Stop God monitoring"
    task :stop, :roles => :app, :on_error => :continue do
      run "god unmonitor #{application}"
    end

    desc "Start God monitoring"
    task :start, :roles => :app do
      run "god load #{current_path}/config/application.god"
      run "god monitor #{application}"
    end

    desc "Status of God monitoring"
    task :status, :roles => :app do
      run "god status"
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

  desc "Bootstrap initial app and setup database"
  task :cold_bootstrap do
    update
    setup_db
    start
  end

  desc "Setup db"
  task :setup_db do
    run "cd #{release_path} && rake n2:setup"
  end

  desc "Run rake after deploy tasks"
  task :rake_post_deploy do
    path = rake_post_path || release_path
    run "cd #{path} && /usr/bin/rake n2:deploy:after RAILS_ENV=#{rails_env}"
  end

  desc "Load the app skin if it exists"
  task :load_skin do
    if skin_dir_exists? and skin_file_exists?
    	run "ln -nfs /data/config/n2_sites/#{application}/app/stylesheets/skin.sass #{release_path}/app/stylesheets/skin.sass"
    	run "rm -r #{release_path}/public/images"
    	run "ln -nfs /data/config/n2_sites/#{application}/public/images #{release_path}/public/images"
    end
  end

  desc "restore sitemap files in public after deploy"
  task :restore_previous_sitemap do
      run "if [ -e #{current_path}/public/sitemap_index.xml.gz ]; then cp #{current_path}/public/sitemap* #{release_path}/public/; fi"
  end


end


#########################################################################
# Helper Methods
#########################################################################

def skin_dir_exists?
  dir_exists? "/data/config/n2_sites/#{application}"
end

def skin_file_exists?
  file_exists? "/data/config/n2_sites/#{application}/app/stylesheets/skin.sass"
end

def dir_exists? path
  'yes' == capture("if [ -d #{path} ]; then echo 'yes'; fi").strip
end

def file_exists? path
  'yes' == capture("if [ -e #{path} ]; then echo 'yes'; fi").strip
end
