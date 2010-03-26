# Load ActiveRecord Base Model Extensions
require "#{RAILS_ROOT}/lib/activerecord_model_extensions.rb"
ActiveRecord::Base.send :include, Newscloud::ActiverecordModelExtensions

# Load acts_as_featured_item mixin
require "#{RAILS_ROOT}/lib/acts_as_featured_item.rb"
ActiveRecord::Base.send :include, Newscloud::Acts::FeaturedItem

# Load acts_as_media_item mixin
require "#{RAILS_ROOT}/lib/acts_as_media_item.rb"
ActiveRecord::Base.send :include, Newscloud::Acts::MediaItem

# Load acts_as_moderatable mixin
require "#{RAILS_ROOT}/lib/acts_as_moderatable.rb"
ActiveRecord::Base.send :include, Newscloud::Acts::Moderatable

# Load acts_as_refineable mixin
require "#{RAILS_ROOT}/lib/acts_as_refineable.rb"
ActiveRecord::Base.send :include, Newscloud::Acts::Refineable

require "#{RAILS_ROOT}/lib/locale_extensions.rb"
