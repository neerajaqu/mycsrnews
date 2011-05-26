unless Capistrano::Configuration.respond_to?(:instance)
  abort "Capistrano 2 is required"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    #
    # Borrowed from http://seancribbs.com/tasty-recipes-for-capistrano
    #
    desc <<-DESC
      Tail environment rails server log.
    DESC
    task :tail_log, :roles => :app do
      sudo "tail -f #{shared_path}/log/#{rails_env}.log"
    end

    set :rake_cmd, (ENV['RAKE_CMD'] || nil)
    desc <<-DESC
      Execute remote rake command.
    DESC
    task :rake_exec do
      if rake_cmd
        run "cd #{current_path} && #{rake} #{rake_cmd} RAILS_ENV=#{rails_env}"
      end
    end

    desc <<-DESC
      Clear database sessions.
    DESC
    task :clear_sessions do
      set :rake_cmd, "db:sessions:clear"
      rake_exec
    end
  end
end
