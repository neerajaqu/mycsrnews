require 'yaml'
require 'resque'

rails_root = ENV['RAILS_ROOT'] || File.expand_path(File.dirname(__FILE__) + '/../..')
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]
APP_CONFIG['redis'] = resque_config[rails_env]

app_name = rails_root =~ %r(/([^/]+)/(current|release)) ? $1 : nil
APP_CONFIG['namespace'] = app_name
Resque.redis.namespace = "resque:#{app_name}" if app_name
$redis = Newscloud::Redcloud.create

require 'resque_scheduler'
Resque.schedule = YAML.load_file(File.join(rails_root, 'config/resque_schedule.yml'))

begin
  NotificationWorker.class
  PFEED_RESQUE_KLASS = NotificationWorker
rescue NameError
end
