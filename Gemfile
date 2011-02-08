source :gemcutter
gem "rails", "2.3.4"


gem 'compass', '~> 0.10.0'
gem 'compass-960-plugin'
gem 'json', '1.4.6'
gem 'mogli'

gem "rack", '1.0.1'
gem "formtastic", "1.1.0"
gem "friendly_id", '2.2.7'
gem 'will_paginate', '~> 2.3.11'
gem "tzinfo", '0.3.23'
gem "oauth"
gem "twitter"
gem "mysql"
gem "bitly", "0.5.1"
gem "redis"
gem "redis-namespace"
gem "resque"
gem "resque-scheduler", :require => 'resque_scheduler'
gem 'sitemap_generator'
gem "SystemTimer"
gem "aasm"
gem "acl9"

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
end

group :test, :cucumber do
	gem "rspec", "1.3.0"
	gem "rspec-rails", "1.3.2"
	gem "faker"
	gem "database_cleaner", :git => "git://github.com/bmabey/database_cleaner.git"
	gem "capybara", :git => "git://github.com/jnicklas/capybara.git"
	#gem "capybara-envjs"
	gem "cucumber"
	gem "cucumber-rails"
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
