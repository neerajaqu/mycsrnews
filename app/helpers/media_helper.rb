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
        url = image.images.first.try(:thumb_url)
      when Content.name
        url = image.images.first.try(:thumb_url)
      when Article.name
        url = image.content.images.first.try(:medium_url)
      when Resource.name
        url = image.images.first.try(:thumb_url)
      else
      	url = nil
    end
    url || default_image
  end

  def medium_image_or_default image
    url = nil
    case image.class.name
      when String.name
        url = image
      when Gallery.name
        url = image.medium_url
      when Image.name
        url = image.medium_url
      when Video.name
        url = image.medium_url
      when Classified.name
        url = image.images.first.try(:medium_url)
      when Content.name
        url = image.images.first.try(:medium_url)
      when Article.name
        url = image.content.images.first.try(:medium_url)
      when Resource.name
        url = image.images.first.try(:medium_url)
      else
      	url = nil
    end
    url || default_medium_image
  end
  
end
