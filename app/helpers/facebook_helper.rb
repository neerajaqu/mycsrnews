# Methods added to this helper will be available to all templates in the application.
module FacebookHelper

  def fb_mp3(src, options = {})
    tag "fb:mp3", options.merge(:src => src)
  end
      
end
