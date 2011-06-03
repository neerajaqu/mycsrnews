class Admin::ContentDashboardController < AdminController
  def index
  end

  def news_topics
    if request.put? or request.post?
      params["topic_form"]["feeds"].each do |feed_id, settings|
        feed = Feed.find(feed_id)
        feed.update_attribute("enabled", true) if settings["enabled"]
        feed.update_attribute("load_all", settings["autopost"])
        feed.update_attribute(:user, current_user)
      end

      flash[:success] = "Successfully Updated your feeds."
      redirect_to admin_feeds_path
    else
      @feed_topics = Feed.default_feed_topics
    end
  end
end
