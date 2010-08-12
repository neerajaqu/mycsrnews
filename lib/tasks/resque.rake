task "resque:setup" => :environment

#remove_task "resque:scheduler_setup"
task "resque:scheduler_setup" do
    puts "In custom setup with path #{ENV['load_path']}"
  path = ENV['load_path']
  load path.to_s.strip if path
end

=begin
namespace :resque do
  task :zzscheduler_setup do
    puts "In custom setup with path #{ENV['load_path']}"
    path = ENV['load_path']
    load path.to_s.strip if path
  end
end
=end
