rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')
Resque.redis = resque_config[rails_env]

app_name = RAILS_ROOT =~ %r(/([^/]+)/(current|release)) ? $1 : nil
Resque.redis.namespace = "resque:#{app_name}" if app_name

PFEED_RESQUE_KLASS = NotificationWorker
