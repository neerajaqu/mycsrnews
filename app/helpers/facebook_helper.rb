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
begin
    stream_post = Facebooker::StreamPost.new
    attachment = Facebooker::Attachment.new
    attachment.name = "Media"
    stream_post.message = t('shared.sidebar.welcome_panel.welcome_panel_message_fbml')
    stream_post.action_links = [{:text => t('shared.sidebar.welcome_panel.welcome_panel_headline'), :href => home_index_path(:only_path => false, :canvas => true)}]
    stream_post.attachment = attachment
end

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

  def iframe_facebook_request?
    (session and session[:facebook_request]) or request_comes_from_facebook?
  end

  private

  def build_stream_post item
    stream_post = Facebooker::StreamPost.new
    attachment = Facebooker::Attachment.new
    attachment.name = "Media"
    if item.respond_to?(:images) and item.images.present?
    	item.images.each do |image|
    	  attachment.add_image(image_path(image.url(:thumb)), polymorphic_url(item, :only_path => false, :canvas => true))
    	end
    end
    stream_post.message = item.item_description
    stream_post.action_links = [{:text => item.item_title, :href => polymorphic_url(item, :only_path => false, :canvas => true)}]
    stream_post.attachment = attachment

    stream_post
  end

  def build_app_stream_post
    stream_post = Facebooker::StreamPost.new
    attachment = Facebooker::Attachment.new
    attachment.name = "Media"
    stream_post.message = t('shared.sidebar.welcome_panel.welcome_panel_message_fbml')
    stream_post.action_links = [{:text => t('shared.sidebar.welcome_panel.welcome_panel_headline'), :href => home_index_path(:only_path => false, :canvas => true)}]
    stream_post.attachment = attachment

    stream_post
  end
      
end
