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

  def self.expire_some filter = nil, controller = nil
    widgets = self.widgets
    controller ||= ActionController::Base.new
    regex = {:top => /^top|most/, :newest => /^newest/}

    widgets.each do |widget|
      next unless !filter or widget =~ regex[filter]

      puts "Expiring fragment: #{widget}"
      controller.expire_fragment "#{widget}_html"
      controller.expire_fragment "#{widget}_fbml"
    end
  end

  def self.widgets
    ['top_stories', 'stories_list', 'active_stories', 'most_discussed_stories', 'top_users', 'top_ideas', 'top_events', 'featured_items', 'newest_users', 'newest_ideas', 'header', 'fan_application', 'prompt_permissions']
  end

end
