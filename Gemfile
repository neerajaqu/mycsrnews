source :gemcutter

gem "rails", "2.3.11"
gem "rack", '1.1.0'


gem "haml", "3.0.25"
gem 'compass', '~> 0.10.0'
gem 'compass-960-plugin'
gem 'json', '1.4.6'
gem 'mogli'

gem "formtastic", "1.1.0"
gem "friendly_id", '2.2.7'
gem 'will_paginate', '~> 2.3.11'
gem "tzinfo", '0.3.23'
gem "oauth"
gem "twitter"
gem "mysql"
gem "bitly"
gem "redis"
gem "redis-namespace"
gem "resque"
gem "resque-scheduler", :require => 'resque_scheduler'
gem 'sitemap_generator'
gem "SystemTimer"
gem "aasm"
gem "acl9"
gem "paperclip"
#gem "ruby-aaws"
gem 'amazon-ecs', :git => 'git://github.com/stipple/amazon-ecs.git'

# switched from vendor/plugins
gem "hoptoad_notifier"
gem "newrelic_rpm"
gem "acts-as-taggable-on"

#gem 'redis-store', '= 1.0.0.beta2', :git => 'https://github.com/jodosha/redis-store.git', :ref => '20d5a4d3741095b3509d'
gem 'redis-store', '= 1.0.0.beta5'

# Rails_xss plugin requirements
gem 'erubis'

# Feedzirra related
gem 'nokogiri'
gem 'loofah', '0.4.7'
gem 'builder', '2.1.2'
gem 'curb', :git => 'git://github.com/taf2/curb.git'
gem 'sax-machine', :git => 'git://github.com/pauldix/sax-machine.git'

source("http://gems.github.com") { gem "mdalessio-dryopteris", "0.1.2" }

#gem 'feedzirra', '0.0.18.1'
gem 'feedzirra', :git => 'git://github.com/chewbranca/feedzirra.git'

group :development do
  gem "wirble"
  gem "awesome_print"
	gem "faker"
end

group :test, :cucumber do
	gem "rspec", "1.3.0"
	gem "rspec-rails", "1.3.2"
	gem "faker"
	gem "database_cleaner", :git => "git://github.com/bmabey/database_cleaner.git"
	gem "capybara", :git => "git://github.com/jnicklas/capybara.git"
	#gem "capybara-envjs"
	gem "cucumber"
	gem "cucumber-rails", "0.3.2"
	gem "factory_girl"
	#gem "email_spec"
	gem "rcov"
	gem "faker"
	gem "pickle"
	gem "launchy"
	gem "ZenTest"
	gem "rr"
end

group :production do
  gem "unicorn", "0.95.2"
end
