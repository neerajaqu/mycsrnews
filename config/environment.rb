# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Reserved names for friendly_id slugs
RESERVED_NAMES = ["admin", "administrator", "update", "delete", "show", "create", "new", "newscloud", "n2", "edit"] unless defined?(RESERVED_NAMES)

# Load ActiveRecord Base Model Extensions
#require "#{RAILS_ROOT}/lib/activerecord_model_extensions.rb"
#ActiveRecord::Base.send :include, Newscloud::ActiverecordModelExtensions

# Load acts_as_featured_item mixin
#require "#{RAILS_ROOT}/lib/acts_as_featured_item.rb"
#ActiveRecord::Base.send :include, Newscloud::Acts::FeaturedItem

# Load acts_as_moderatable mixin
#require "#{RAILS_ROOT}/lib/acts_as_moderatable.rb"
#ActiveRecord::Base.send :include, Newscloud::Acts::Moderatable

# Load Iframe Rewriter Middleware
require "#{RAILS_ROOT}/lib/iframe_rewriter.rb"
require "#{RAILS_ROOT}/lib/facebook_request.rb"

Rails::Initializer.run do |config|
  config.middleware.use Rack::FacebookRequest
  config.middleware.use Newscloud::IframeRewriter

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers #{RAILS_ROOT}/app/workers )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  #config.gem "haml"
  #config.gem "eycap"
  #config.gem "rack"
  #config.gem "formtastic"
  #config.gem "friendly_id"
  #config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  #config.gem "compass"
  #config.gem 'json', :version => '1.4.6'
  #config.gem "compass-960-plugin", :lib => 'ninesixty'
  #config.gem "eostrom-zvent", :lib => 'zvent'
  #config.gem "oauth"
  #config.gem "mogli"
  #config.gem "twitter"
  #config.gem "bitly"
  #config.gem "resque"
  #config.gem "resque-scheduler", :lib => 'resque_scheduler'
  #config.gem 'sitemap_generator', :lib => false
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  #config.active_record.observers = :message_observer, :vote_observer #having issues with vote observer
  config.active_record.observers = :message_observer, :comment_observer, :flag_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Pacific Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :en

  #config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'

  # Set rails cache directory to public/cache
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache"

end

if FileTest.exists?("#{RAILS_ROOT}/config/smtp.yml")
  smtp = YAML::load(File.open("#{RAILS_ROOT}/config/smtp.yml"))
  ActionMailer::Base.smtp_settings = smtp[Rails.env].with_indifferent_access
end

require "#{RAILS_ROOT}/lib/parse.page.rb"
