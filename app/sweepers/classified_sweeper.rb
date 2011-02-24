class ClassifiedSweeper < ActionController::Caching::Sweeper
  observe Classified

  def after_save(record)
    ClassifiedSweeper.expire_classified_all(record, self)
  end

  def after_destroy(record)
    ClassifiedSweeper.expire_classified_all(record, self)
  end

  def self.expire_classified_all classified, controller = ActionController::Base.new
    ["#{classified.cache_key}_top", "#{classified.cache_key}_sidebar", "#{classified.cache_key}_voices", "#{classified.cache_key}_who_liked", 'classifieds_list', 'newest_classifieds', 'top_classifieds', 'featured_classified', "top_classified_category_html"].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "classifieds_list_#{page}html"
    end

  end
end
