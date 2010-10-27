class ResourceSweeper < ActionController::Caching::Sweeper
  observe Resource

  def after_save(resource)
    clear_resource_cache(resource)
  end

  def after_destroy(record)
    clear_resource_cache(resource)
  end

  def clear_resource_cache(resource)
    ['top_resources', 'newest_resources', 'featured_resources', "#{resource.cache_key}_who_liked" ].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "resources_list_#{page}html"
    end
  end

  def self.expire_resource_all resource
    controller = ActionController::Base.new
    ['top_resources', 'newest_resources', 'featured_resources'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "resources_list_#{page}html"
    end
  end

end
