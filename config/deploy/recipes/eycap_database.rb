#
# Borrowed from https://github.com/engineyard/eycap
#
# Copyright (c) 2008-2009 Engine Yard
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

Capistrano::Configuration.instance(:must_exist).load do

  namespace :db do
    task :backup_name, :roles => :db, :only => { :primary => true } do
      now = Time.now
      run "mkdir -p #{shared_path}/db_backups"
      backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
      set :backup_file, "#{shared_path}/db_backups/#{environment_database}-snapshot-#{backup_time}.sql"
    end
  
    desc "Clone Production Database to Staging Database."
    task :clone_prod_to_staging, :roles => :db, :only => { :primary => true } do

      # This task currently runs only on traditional EY offerings.
      # You need to have both a production and staging environment defined in 
      # your deploy.rb file.  

      backup_name
      on_rollback { run "rm -f #{backup_file}" }
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }  

      if @environment_info['adapter'] == 'mysql'
        dbhost = @environment_info['host']
        dbhost = environment_dbhost.sub('-master', '') + '-replica'
        run "mysqldump --add-drop-table -u #{dbuser} -h #{dbhost} -p #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
           ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
        run "bzcat #{backup_file}.bz2 | mysql -u #{dbuser} -p -h #{staging_dbhost} #{staging_database}" do |ch, stream, out|
           ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
      else
        run "pg_dump -W -c -U #{dbuser} -h #{production_dbhost} #{production_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out|
           ch.send_data "#{dbpass}\n" if out=~ /^Password:/
        end
        run "bzcat #{backup_file}.bz2 | psql -W -U #{dbuser} -h #{staging_dbhost} #{staging_database}" do |ch, stream, out|
           ch.send_data "#{dbpass}\n" if out=~ /^Password/
        end
      end
      run "rm -f #{backup_file}.bz2"
    end
  
    desc "Backup your MySQL or PostgreSQL database to shared_path+/db_backups"
    task :dump, :roles => :db, :only => {:primary => true} do
      backup_name
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }
      if @environment_info['adapter'] == 'mysql'
        dbhost = @environment_info['host']
        dbhost = environment_dbhost.sub('-master', '') + '-replica' if dbhost != 'localhost' # added for Solo offering, which uses localhost
        run "mysqldump --add-drop-table -u #{dbuser} -h #{dbhost} -p #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
           ch.send_data "#{dbpass}\n" if out=~ /^Enter password:/
        end
      else
        run "pg_dump -W -c -U #{dbuser} -h #{environment_dbhost} #{environment_database} | bzip2 -c > #{backup_file}.bz2" do |ch, stream, out |
           ch.send_data "#{dbpass}\n" if out=~ /^Password:/
        end
      end
    end
    
    desc "Sync your production database to your local workstation"
    task :clone_to_local, :roles => :db, :only => {:primary => true} do
      backup_name
      dump
      get "#{backup_file}.bz2", "/tmp/#{application}.sql.bz2"
      development_info = YAML.load_file("config/database.yml")['development']
      if development_info['adapter'] == 'mysql'
        run_str = "bzcat /tmp/#{application}.sql.bz2 | mysql -u #{development_info['username']} --password='#{development_info['password']}' -h #{development_info['host']} #{development_info['database']}"
      else
        run_str = "PGPASSWORD=#{development_info['password']} bzcat /tmp/#{application}.sql.bz2 | psql -U #{development_info['username']} -h #{development_info['host']} #{development_info['database']}"
      end
      %x!#{run_str}!
    end
  end

end
