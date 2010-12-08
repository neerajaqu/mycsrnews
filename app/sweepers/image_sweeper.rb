class ImageSweeper < ActionController::Caching::Sweeper
  observe Image

  def after_save(image)
    clear_image_cache(image)
  end

  def after_destroy(record)
    clear_image_cache(image)
  end

  def self.expire_image_all image
    controller = ActionController::Base.new
    image.imageable.expire
    ['top_images', 'newest_images', 'gallery_images'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
  end

end
