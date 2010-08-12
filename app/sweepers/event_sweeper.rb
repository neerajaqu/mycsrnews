class EventSweeper < ActionController::Caching::Sweeper
  observe Event

  def after_save(event)
    clear_event_cache(event)
  end

  def after_destroy(record)
    clear_event_cache(event)
  end

  def clear_event_cache(event)
    ['top_events', 'newest_events', 'featured_events', "#{event.cache_key}_who_liked" ].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "events_list_#{page}html"
    end
  end

  def self.expire_event_all event
    controller = ActionController::Base.new
    ['top_events', 'newest_events', 'featured_events'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "events_list_#{page}html"
      controller.expire_fragment "events_list_#{page}fbml"
    end
  end

end
