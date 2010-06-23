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
  end
end

def worker_pids
  Resque.workers.inject([]) {|pids,worker| pids << worker.to_s.split(':')[-2].to_i }
end
