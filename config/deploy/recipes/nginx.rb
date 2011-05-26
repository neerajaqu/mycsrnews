#
# Borrowed from: https://github.com/webficient/capistrano-recipes
#
#
# Copyright (c) 2009-2011 Webficient LLC, Phil Misiowiec
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Capistrano::Configuration.instance.load do
    
  # Where your nginx lives. Usually /opt/nginx or /usr/local/nginx for source compiled.
  set :nginx_path_prefix, "/etc/nginx" unless exists?(:nginx_path_prefix)

  # Path to the nginx erb template to be parsed before uploading to remote
  set(:nginx_local_config) { "#{template_dir}/nginx.conf.erb" } unless exists?(:nginx_local_config)

  # Path to where your remote config will reside (I use a directory sites inside conf)
  set(:nginx_remote_available_path) do
    #"#{nginx_path_prefix}/sites-available/#{application}.conf"
    "#{nginx_path_prefix}/sites-available/#{application}.conf"
  end unless exists?(:nginx_remote_available_path)

  set(:nginx_remote_enabled_path) do
    #"#{nginx_path_prefix}/sites-available/#{application}.conf"
    "#{nginx_path_prefix}/sites-enabled/#{application}.conf"
  end unless exists?(:nginx_remote_enabled_path)

  set(:nginx_remote_shared_path) do
    #"#{nginx_path_prefix}/sites-available/#{application}.conf"
    "#{shared_path}/#{application}.conf"
  end unless exists?(:nginx_remote_shared_path)

  # Path to nginx error log
  set(:nginx_error_log_path) do
    "/var/log/nginx/nginx.#{application}.error.log"
  end unless exists?(:nginx_error_log_path)

  # Path to nginx access log
  set(:nginx_access_log_path) do
    "/var/log/nginx/nginx.#{application}.access.log"
  end unless exists?(:nginx_access_log_path)

  # Nginx tasks are not *nix agnostic, they assume you're using Debian/Ubuntu.
  # Override them as needed.
  namespace :nginx do
    desc "|DarkRecipes| Parses and uploads nginx configuration for this app."
    task :setup, :roles => :app , :except => { :no_release => true } do
      put(parse_config(nginx_local_config), nginx_remote_shared_path)
      sudo "cp #{nginx_remote_shared_path} #{nginx_remote_available_path}"
      sudo "ln -nfs #{nginx_remote_available_path} #{nginx_remote_enabled_path}"
      nginx.restart
    end
    
    desc "|DarkRecipes| Parses config file and outputs it to STDOUT (internal task)"
    task :parse, :roles => :app , :except => { :no_release => true } do
      puts parse_config(nginx_local_config)
    end
    
    desc "|DarkRecipes| Restart nginx"
    task :restart, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx restart"
    end
    
    desc "|DarkRecipes| Stop nginx"
    task :stop, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx stop"
    end
    
    desc "|DarkRecipes| Start nginx"
    task :start, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx start"
    end

    desc "|DarkRecipes| Show nginx status"
    task :status, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx status"
    end
  end
  
  after 'deploy:setup' do
    nginx.setup if Capistrano::CLI.ui.agree("Create nginx configuration file?") {|q| q.default = "yes" }
  end if is_using_nginx 
end

