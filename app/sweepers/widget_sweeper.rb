class WidgetSweeper < ActionController::Caching::Sweeper

  def self.expire_all
    self.expire_some
  end

  def self.expire_top
    self.expire_some :top
  end

  def self.expire_newest
    self.expire_some :newest
  end
  
  def self.expire_item widget, controller = nil
    controller ||= ActionController::Base.new
    controller.expire_fragment "#{widget}_html"
  end  
  
  def self.expire_features
    feature_list = [ "auto_feature_sidebar", "auto_feature", "featured_items"]
    feature_list.each do |widget|
      self.expire_item widget
    end
  end
  
  def self.expire_some filter = nil, controller = nil
    widgets = self.widgets
    controller ||= ActionController::Base.new
    regex = {:top => /^top|most/, :newest => /^newest/}

    widgets.each do |widget|
      next unless !filter or widget =~ regex[filter]

      puts "Expiring fragment: #{widget}"
      controller.expire_fragment "#{widget}_html"
      #controller.expire_fragment "#{widget}_fbml"
    end
  end

  def self.widgets
    ['latest_activity','newest_newswires','blog_roll','feed_roll','auto_feature','auto_feature_sidebar','top_stories', 'stories_list', 'active_stories', 'most_discussed_stories', 'top_users', 'top_ideas', 'top_events', 'featured_items', 'newest_users', 'newest_ideas', 'header', 'fan_application', 'prompt_permissions', 'newest_images', 'newest_videos','newest_announcements','welcome_panel']
  end

end
