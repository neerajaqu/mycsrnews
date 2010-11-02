# Methods added to this helper will be available to all templates in the application.
module FacebookHelper

  def fb_mp3(src, options = {})
    tag "fb:mp3", options.merge(:src => src)
  end

  def fb_jqjs_library
    "<script>var _token = '#{form_authenticity_token}';var _hostname = '#{ActionController::Base.asset_host}'</script>"+
    "#{javascript_include_tag 'Utility'}"+
    "#{javascript_include_tag 'FBjqRY'}"
  end

  def fb_share_item_button item
    stream_post = build_stream_post item
    render :partial => 'shared/misc/share_button', :locals => {:item => item, :stream_post => stream_post}
  end

  def fb_share_app_button
    stream_post = Facebooker::StreamPost.new
    attachment = Facebooker::Attachment.new
	  attachment.add_image(image_path('default/icon-fan-app.gif'), home_index_path(:only_path => false, :canvas => true))
    stream_post.message = t('header.share_description')
    stream_post.action_links = [{:text => t('facebook_learn_more'), :href => home_index_path(:only_path => false, :canvas => true)}]
    stream_post.attachment = attachment

    render :partial => 'shared/misc/share_app_button', :locals => {:stream_post => stream_post}
  end

  def fb_meta_share_button item
    text = %{<fb:share-button class="meta"><meta name="medium" content="news" />}
    text += %{<meta name="title" content="#{item.item_title}" />}
    text += %{<meta name="description" content="#{caption(strip_tags(item.item_description),200)}" />}
    if item.respond_to?(:images) and item.images.present?
    	text += %{<link rel="image_src" href="#{meta_image item.images.first}"}
    end
    text += %{<link rel="target_url" href="#{polymorphic_path(item, :only_path => false, :canvas => true)}"}
    text += %{</fb:share-button>}
    text
  end

  private

  def build_stream_post item
    stream_post = Facebooker::StreamPost.new
    stream_post.message = caption(strip_tags(item.wall_caption),400) # 420 is fb limit
    stream_post.action_links = [{:text => t('facebook_learn_more'), :href => polymorphic_url(item.item_link, :only_path => false, :canvas => true)}]
    attachment = Facebooker::Attachment.new
    if item.respond_to?(:images) and item.images.present?
    	item.images.each do |image|
    	  attachment.add_image(image_path(image.url(:thumb)), polymorphic_url(item.item_link, :only_path => false, :canvas => true))
    	end
    end
    attachment.name = item.item_title
    attachment.description = caption(strip_tags(item.item_description),999) # 999 is fb limit
    attachment.href = polymorphic_url(item.item_link, :only_path => false, :canvas => true)
    stream_post.attachment = attachment
    stream_post
  end

  def build_app_stream_post
    # todo - is this not being used
    stream_post = Facebooker::StreamPost.new
    stream_post.message = ''
    stream_post.action_links = [{:text => t('facebook_learn_more'), :href => home_index_path(:only_path => false, :canvas => true)}]
    attachment = Facebooker::Attachment.new
    attachment.name = APP_CONFIG['site_title']
    attachment.description = t('header.share_description')
    attachment.href = home_index_path(:only_path => false, :canvas => true)
	  attachment.add_image(image_path('default/icon-fan-app.gif'), home_index_path(:only_path => false, :canvas => true))
    stream_post.attachment = attachment
    stream_post
  end

  def fb_profile_link user
    "http://www.facebook.com/profile.php?id=#{user.fb_user_id}"
  end

end
