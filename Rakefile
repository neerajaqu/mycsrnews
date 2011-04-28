# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'thread'
require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'resque/tasks'
require 'resque_scheduler/tasks'

begin
   require 'sitemap_generator/tasks'
 rescue Exception => e
   puts "Warning, couldn't load gem tasks: #{e.message}! Skipping..."
end

# Load paperclip tasks
import File.expand_path(File.join(Gem.datadir('paperclip'), '..', '..', 'lib', 'tasks', 'paperclip.rake'))