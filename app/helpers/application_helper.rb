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
  
  def path_to_self(item)
    url_for(send("#{item.class.to_s.underscore}_url", item))
  end

  def link_to_path_to_self(item)
    link_to url_for(send("#{item.class.to_s.underscore}_url", item)), url_for(send("#{item.class.to_s.underscore}_url", item))
  end

  def twitter_share_item_link(item,caption)
    caption = strip_tags(caption)
    url = path_to_self(item)
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

  def embed_video video, options = {}
    request_comes_from_facebook? ? embed_fb_video(video, options) : embed_html_video(video, options)
  end

  def embed_fb_video video, options = {}
    options[:width] ||= '425'
    options[:height] ||= '344'

    fb_swf video.video_src, options
  end

  def embed_html_video video, options = {}
    options[:width] ||= '425'
    options[:height] ||= '344'
    <<EMBED
<object width="#{options[:height]}" height="#{options[:width]}">
  <param name="movie" value="#{video.video_src}"></param>
  <param name="allowFullScreen" value="true"></param>
  <param name="allowscriptaccess" value="always"></param>
  <embed src="#{video.video_src}" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed>
</object>
EMBED
  end

  def embed_audio audio, options = {}
    request_comes_from_facebook? ? embed_fb_audio(audio, options) : embed_html_audio(audio, options)
  end

  def embed_fb_audio audio, options = {}
    fb_mp3 audio.url, :title => audio.title, :artist => audio.artist, :album => audio.album
  end

  def embed_html_audio audio, options = {}
    <<EMBED
<embed src= "http://www.odeo.com/flash/audio_player_standard_gray.swf" quality="high" width="300" height="52" allowScriptAccess="always" wmode="transparent"  type="application/x-shockwave-flash" flashvars= "valid_sample_rate=true&external_url=#{audio.url}" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>
EMBED
  end

  def render_media_items item
    return false unless item.media_item?
    output = []
    ['audio', 'video', 'image'].each do |media|
      next unless item.send("#{media}_item?")
      output << render(:partial => "shared/media/#{media.pluralize}", :locals => { media.pluralize.to_sym => item.send(media.pluralize.to_sym) })
    end
    output.join
  end

  def sanitize_user_content content
    sanitize content, :tags => %w(a i b u p)
  end

  def toggle_blocked_link item
    return '' unless item.moderatable? and item.blockable?
    link_to(item.blocked? ? 'UnBlock' : 'Block', toggle_blocked_path(item.class.name.foreign_key.to_sym => item))
  end

  def toggle_featured_link item
    return '' unless item.moderatable? and item.featurable?
    link_to(item.is_featured? ? 'UnFeature' : 'Feature', toggle_featured_path(item.class.name.foreign_key.to_sym => item))
  end

end
