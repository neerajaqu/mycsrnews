namespace :n2 do
  namespace :queue do
    desc "Restart Resque workers"
    task :restart_workers => [:environment, :stop_workers] do
      # Stop workers and let god restart them
    end

    desc "Stop Resque workers"
    task :stop_workers => :environment do
      pids = worker_pids
      puts "Stopping Resque workers with pids: #{pids.inspect}"
      system("kill -QUIT #{pids.join ' '}") if pids.any?
    end

    desc "Restart Resque scheduler"
    task :restart_scheduler => [:stop_scheduler] do
      # Stop scheduler and let god restart them
    end

    desc "Stop Resque Scheduler"
    task :stop_scheduler do
      raise "You must specify the ENV variable APP_NAME" unless ENV['APP_NAME'].present?
      puts "Stopping Resque Scheduler"
      system("ps aux | grep 'resque:scheduler' | grep #{ENV['APP_NAME']} | grep -v grep | awk '{ print $2 }' | xargs -r kill")
    end
  end
end

def worker_pids
  Resque.workers.inject([]) {|pids,worker| pids << worker.to_s.split(':')[-2].to_i }
end
