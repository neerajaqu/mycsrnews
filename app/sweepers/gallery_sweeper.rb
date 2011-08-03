class GallerySweeper < ActionController::Caching::Sweeper
  observe Gallery, GalleryItem

  def after_save(record)
    if record.is_a?(Gallery)
      GallerySweeper.expire_gallery_all(record, self)
    elsif record.is_a?(GalleryItem)
      GallerySweeper.expire_gallery_item_all(record, self)
    end
  end

  def after_destroy(record)
    if record.is_a?(Gallery)
      GallerySweeper.expire_gallery_all(record, self)
    elsif record.is_a?(GalleryItem)
      GallerySweeper.expire_gallery_item_all(record, self)
    end
  end

  def self.expire_gallery_all gallery, controller = ActionController::Base.new
    [gallery.cache_key, "#{gallery.cache_key}_sidebar", "#{gallery.cache_key}_voices", "#{gallery.cache_key}_who_liked", 'galleries_list', 'newest_galleries', 'top_galleries', 'featured_gallery', 'gallery_big_image', 'gallery_small_images'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "galleries_list_#{page}html"
    end

    NewscloudSweeper.expire_instance(gallery)
  end

  def self.expire_gallery_item_all gallery_item, controller = ActionController::Base.new
    ["#{gallery_item.gallery.cache_key}_voices", "#{gallery_item.gallery.cache_key}_who_liked"].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end

    GallerySweeper.expire_gallery_all gallery_item.gallery, controller
    NewscloudSweeper.expire_instance(gallery)
  end

end
