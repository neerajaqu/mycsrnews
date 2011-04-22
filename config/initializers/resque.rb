require 'yaml'
require 'resque'

rails_root = ENV['RAILS_ROOT'] || File.expand_path(File.dirname(__FILE__) + '/../..')
rails_env = ENV['RAILS_ENV'] || 'development'

# HACK for when we use this initializer to spawn workers shedulers and resque web
unless defined?(APP_CONFIG)
  APP_CONFIG = {}
end

resque_base_file = rails_root + '/config/resque.yml'
resque_file = File.exists?(resque_base_file) ? resque_base_file : (resque_base_file + '.sample')
resque_config = YAML.load_file(resque_file)
Resque.redis = resque_config[rails_env]
APP_CONFIG['redis'] = resque_config[rails_env]

app_name = rails_root =~ %r(/([^/]+)/(current|release)) ? $1 : nil
APP_CONFIG['namespace'] = app_name
Resque.redis.namespace = "resque:#{app_name}" if app_name

# If we're in rails, set the global redis connection
if defined?(Newscloud)
  $redis = Newscloud::Redcloud.create
end

require 'resque_scheduler'
Resque.schedule = YAML.load_file(File.join(rails_root, 'config/resque_schedule.yml'))

begin
  NotificationWorker.class
  PFEED_RESQUE_KLASS = NotificationWorker
rescue NameError
end
