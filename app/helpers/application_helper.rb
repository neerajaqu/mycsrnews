# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def pipe_spacer
    '<span class="pipe">|</span>'
  end

  def tab_selected?(current_tab, tab_name)
    current_tab == tab_name ? "selected" : ''
  end

  def sub_tab_selected?(current_sub_tab, sub_tab_name)
    current_sub_tab == sub_tab_name ? "selected" : ''
  end

  def default_bio(user)
    "Hi my name is #{local_linked_profile_name user} and I forgot to add my bio. Next time you see me remind me to update my bio information."
  end

  def build_feed_link(action)
    action_type = action.class.name
    if action_type == 'Content'
    	base_url(story_path(action, :canvas => false))
    elsif action_type == 'Comment'
    	base_url(story_path(action.content, :canvas => false))
    elsif action_type == 'Vote'
    	base_url(story_path(action.voteable, :canvas => false))
    else
    	''
    end
  end

  def build_feed_title(action, user)
    action_type = action.class.name
    if action_type == 'Content'
    	"#{user.name} posted #{action.title}"
    elsif action_type == 'Comment'
    	"#{user.name} just commented on #{action.content.title}"
    elsif action_type == 'Vote'
    	"#{user.name} liked #{action.voteable.title}"
    else
    	''
    end
  end

  def build_feed_blurb(action, user)
    action_type = action.class.name
    if action_type == 'Content'
    	"#{user.name} posted #{linked_story_caption(action, 150, build_feed_link(action))}"
    elsif action_type == 'Comment'
    	"#{user.name} just commented on #{action.content.title}: #{action.comments}"
    elsif action_type == 'Vote'
    	"#{user.name} liked #{action.voteable.title}"
    else
    	''
    end
  end

  def build_feed_item(action, action_type)
    if action_type == 'Content'
    	if action.is_article?
    	  render :partial => 'shared/feed_items/article', :locals => { :article => action }
    	else
    	  render :partial => 'shared/feed_items/story', :locals => { :story => action }
    	end
    elsif action_type == 'Comment'
    	render :partial => 'shared/feed_items/comment', :locals => { :comment => action }
    elsif action_type == 'Vote'
    	render :partial => 'shared/feed_items/vote', :locals => { :vote => action }
    end
  end

  def linked_story_caption(story, length = 150, url = false)
    caption = caption(story.caption, length)
    "#{caption} #{link_to 'More', (url ? url : story_path(story))}"
  end

  def linked_newswire_caption(newswire, length = 150)
    caption = caption(newswire.caption, length)
    "#{caption} #{link_to 'More', newswire.url, :target => "_cts"}"
  end

  def linked_comment_caption(comment, length = 150)
    caption = caption(comment.comments, length)
    "#{caption} #{link_to 'More', story_path(comment.content, :anchor => 'commentsListTop')}"
  end

  def caption(text, length = 150)
    text.length <= length ? text : text[0, length] + '...'
  end

  def voteable_type_name(vote)
    type = vote.voteable.class.name
    if type == 'Content'
    	vote.voteable.is_article? ? 'article' : 'story'
    elsif type == 'Comment'
      'comment'
    elsif type == 'Idea'
      'idea'
    else
    	type
    end
  end

  def voteable_type_link(vote)
    type = vote.voteable.class.name
    if type == 'Content'
    	link_to vote.voteable.title, story_path(vote.voteable)
    elsif type == 'Comment'
    	link_to vote.voteable.title, story_path(vote.voteable, :anchor => "commentListTop")
    elsif type == 'Idea'
      link_to 'Idea', '#'
    else
    	''
    end
  end

  def local_linked_profile_pic(user, options={})
    if user.facebook_user?
      options.merge!(:linked => false)
      link_to fb_profile_pic(user, options), user_path(user)
    else
      link_to image_tag(default_image), user
    end
  end

  def local_linked_profile_name(user, options={})
    if user.facebook_user?
      options.merge!(:linked => false)
      link_to fb_name(user, options), user_path(user)
    else
      link_to user.name, user
    end
  end

  def nl2br(string)
    string.gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
  end

  def profile_fb_name(user)
    fb_name(user, :use_you => true, :possessive => true, :capitalize => true)
  end

  def twitter_share_story_link(story)
    caption = caption strip_tags(story.caption)
    url = story_url(story)
    text = CGI.escape("#{caption} #{url}")
    twitter_url = "http://twitter.com/?status=#{text}"
    link_to image_tag('/images/default/tweet_button.gif'), twitter_url, :class => "tweetButton"
  end

  def base_url(path)
    if APP_CONFIG['base_url'].present?
    	"#{APP_CONFIG['base_url']}#{path}"
    end
  end

  def fb_list_of_names(fb_user_ids)
    return false if fb_user_ids.empty?
    return fb_name(fb_user_ids.first) if fb_user_ids.size == 1

    last = fb_user_ids.pop
    "#{fb_user_ids.collect { |c| fb_name c }.join ', '} and #{fb_name last}"
  end

  def twitter_url(query)
    "http://twitter.com/#{query}"
  end

  def flash_messages
    messages = []
    [:success, :notice, :error, :warning].each do |type|
      messages << content_tag(:div, content_tag(:p, flash[type]), :class => "flash flash_#{type}") if flash[type].present?
      flash[type] = nil
    end
    
    (messages.size > 0) ? messages.join : ''
  end

  def ar_xid(record)
    "#{record.class.model_name.tableize}-#{record.id}"
  end

  def tag_list(tags, item)
    tag_list = []
    tag_cloud(tags, %w(css1 css2 css3 css4)) do |tag, css_class|
      tag_list << link_to(tag.name, tag_link(tag, item), :class => css_class)
    end

    tag_list.size > 0 ? tag_list.join('&nbsp;') : ''
  end

  def tag_link(tag, item)
    if item.class.name == 'Content'
    	tagged_stories_path(:tag => tag.name)
    else
    	[item.class, tag]
    end
  end

  def default_image
    APP_CONFIG['default_image']
  end

  def display_facebook_messages
    flash[:notice] = flash[:success] if flash[:notice].nil? and flash[:success].present?

    facebook_messages
  end

  def embed_fb_swf src, options = {}
    options[:width] ||= '425'
    options[:height] ||= '344'

    fb_swf src, options
  end

end
