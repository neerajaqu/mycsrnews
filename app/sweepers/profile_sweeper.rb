class ProfileSweeper < ActionController::Caching::Sweeper
  observe UserProfile

  def after_save(profile)
    return false unless profile.changed?

    if profile.bio_changed?
    	clear_bio_cache(profile)
    end

  end

  def clear_bio_cache(profile)
    profile.user.contents.each do |story|
      expire_page :controller => '/stories', :action => 'show', :id => story, :format => 'html'
      expire_page :controller => '/stories', :action => 'show', :id => story, :format => 'fbml'
      expire_fragment "#{story.cache_key}_html"
      expire_fragment "#{story.cache_key}_fbml"
    end
  end

end
