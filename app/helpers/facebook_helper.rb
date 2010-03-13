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
      
end
