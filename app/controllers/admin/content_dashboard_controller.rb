class Admin::ContentDashboardController < AdminController
  def index
  end

  def news_topics
    if request.put?
      items = params["topic_form"]["feeds"].map do |feed_id, settings|
        feed = Feed.find(feed_id)
        feed.update_attribute("enabled", true) if settings["enabled"]
        feed.update_attribute("load_all", settings["autopost"])
        [settings, Feed.find(feed_id)]
      end

      raise items.inspect
    end

    @feed_topics = Feed.default_feed_topics
  end
end
