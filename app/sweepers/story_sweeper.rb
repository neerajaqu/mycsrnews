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
    expire_page :controller => 'stories', :action => 'index'
    expire_page :controller => 'home', :action => 'index'
    expire_page :controller => 'stories', :action => 'show', :id => story
    expire_page root_path
  end

end
