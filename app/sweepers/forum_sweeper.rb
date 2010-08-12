class ForumSweeper < ActionController::Caching::Sweeper
  observe Forum, Topic

  def after_save(record)
    if record.is_a?(Forum)
      self.expire_forum_all(record)
    elsif record.is_a?(Topic)
      self.expire_topic_all(record)
    end
  end

  def after_destroy(record)
    if record.is_a?(Forum)
      self.expire_forum_all(record)
    elsif record.is_a?(Topic)
      self.expire_topic_all(record)
    end
  end

  def self.expire_forum_all forum
    controller = ActionController::Base.new
    ['forums_list', "#{forum.cache_key}_topics_list"].each do |fragment|
      controller.expire_fragment fragment
    end
  end

  def self.expire_topic_all topic
    controller = ActionController::Base.new
    ["#{topic.cache_key}_voices", "#{topic.cache_key}_who_liked" ].each do |fragment|
      controller.expire_fragment fragment
    end

    self.expire_forum_all topic.forum
  end

end
