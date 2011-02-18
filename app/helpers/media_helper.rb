module MediaHelper
  
  def thumb_image_or_default image
    url = nil
    case image.class.name
      when String.name
        url = image
      when Gallery.name
        url = image.thumb_url
      when Image.name
        url = image.thumb_url
      when Video.name
        url = image.thumb_url
      when Classified.name
        url = image.images.first
      else
      	url = nil
    end
    url || 'default/watermark.jpg'
  end

end
