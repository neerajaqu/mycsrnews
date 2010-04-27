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
    fb_share_button(polymorphic_url(item, :only_path => false))
  end

  def fb_meta_share_button item
    text = %{<fb:share-button class="meta"><meta name="medium" content="news" />}
    text += %{<meta name="title" content="#{item.item_title}" />}
    text += %{<meta name="description" content="#{item.item_description}" />}
    if item.respond_to?(:images) and item.images.present?
    	text += %{<link rel="image_src" href="#{meta_image item.images.first}"}
    end
    text += %{<link rel="target_url" href="#{polymorphic_path(item, :only_path => false)}"}
    text += %{</fb:share-button>}

    text
  end
      
end
