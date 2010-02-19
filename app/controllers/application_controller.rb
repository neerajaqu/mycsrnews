class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem

  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_current_tab
  before_filter :set_current_sub_tab
  before_filter :set_locale
  before_filter :update_last_active

  #facebook settings
  # TODO:: get this working
  #ensure_application_is_installed_by_facebook_user  
  #ensure_authenticated_to_facebook
  #To prevent a violation of Facebook Terms of Service while reducing log bloat, you should also add 
  filter_parameter_logging :fb_sig_friends


  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :set_facebook_session
  helper_method :facebook_session

  def set_current_tab
    @current_tab = false
  end

  def set_current_sub_tab
    @current_sub_tab = false
  end

  def load_top_stories
    @top_stories ||= Content.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "votes.count desc"
    })
  end

  def load_top_users
    @top_users ||= User.top
  end

  def load_contents
    @contents ||= Content.find(:all, :limit => 10, :order => "created_at desc")
  end

  def load_newest_users
    @newest_users ||= User.newest
  end

  def load_top_discussed_stories
    @most_discussed_stories ||= Content.find( :all,
    	:limit    => 5,
    	:order    => "comments_count desc"
    )
  end

  def load_top_ideas
    @top_ideas ||= Idea.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "votes.count desc"
    })
  end

  def load_newest_ideas
    @newest_ideas ||= Idea.newest
  end

  def load_featured_ideas
    @featured_ideas ||= Idea.featured
  end

  def load_featured_items
    @featured_items ||= FeaturedItem.find_root_by_item_name('featured_template')
  end
  
  def load_newest_idea_boards
    @newest_idea_boards ||= IdeaBoard.newest 5
  end

  def load_newest_resource_sections
    @newest_resource_sections ||= ResourceSection.newest 5
  end

  def load_top_resources
    @top_resources ||= Resource.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "votes.count desc"
    })
  end
  
  def load_newest_resources
    @newest_resources ||= Resource.newest 5
  end

  def load_top_events
    @top_events ||= Event.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "votes.count desc"
    })
  end

  def load_newest_events
    @newest_events ||= Event.newest 5
  end

  def set_locale
    locale = params[:locale] || cookies[:locale] || I18n.default_locale
    I18n.locale = locale.to_s
    cookies[:locale] = locale unless (cookies[:locale] && cookies[:locale] == locale)
  end

  def default_url_options(options={})
    format = options[:format] || request.format.to_sym
    { :locale => I18n.locale,
      :format => format
    } 
  end

  def tag_cloud(item)
    @tags = item.tag_counts_on(:tags)
  end

  def update_last_active
    return false unless current_user.present?

    current_user.last_active = Time.now
    current_user.save
  end

end
