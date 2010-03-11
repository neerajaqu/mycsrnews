class StorySweeper < ActionController::Caching::Sweeper
  observe Content, Comment, Vote

  def after_save(record)
    if record.is_a?(Content)
    	story = record
    elsif record.is_a?(Comment) and record.commentable.is_a?(Content)
      story = record.commentable
    elsif record.is_a?(Vote) and record.voteable.is_a?(Content)
      story = record.voteable
    else
    	story = false
    end

    clear_story_cache(story) if story
  end

  def after_destroy(record)
    if record.is_a?(Content)
    	story = record
    elsif record.is_a?(Comment)
      story = record.content
    elsif record.is_a?(Vote) and record.voteable.is_a?(Content)
      story = record.voteable
    else
    	story = false
    end

    clear_story_cache(story) if story
  end

  def clear_story_cache(story)
    #expire_page :controller => '/stories', :action => 'index', :format => 'html'
    #expire_page :controller => '/stories', :action => 'index', :format => 'fbml'
    #expire_page :controller => '/home', :action => 'index', :format => 'html'
    #expire_page :controller => '/home', :action => 'index', :format => 'fbml'
    #expire_page :controller => '/stories', :action => 'show', :id => story, :format => 'html'
    #expire_page :controller => '/stories', :action => 'show', :id => story, :format => 'fbml'
    ['top_stories', 'stories_list', 'active_users', 'most_discussed_stories', 'top_users', 'top_ideas', 'top_events', 'featured_items', 'newest_users', 'newest_ideas', 'header', 'fan_application', 'prompt_permissions'].each do |fragment|
      expire_fragment "#{fragment}_html"
      expire_fragment "#{fragment}_fbml"
    end
    #expire_page root_path
  end

  def self.expire_story_all story
    controller = ActionController::Base.new
    ['top_stories', 'stories_list', 'featured_items', story.cache_key, 'most_discussed_stories'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
  end

end
