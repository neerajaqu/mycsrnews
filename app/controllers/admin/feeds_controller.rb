class Admin::FeedsController < AdminController

  admin_scaffold :feed do |config|
    config.index_fields = [:title, :url, :rss, :last_fetched_at, :newswires_count, :user_id]
    config.extra_scopes = [:enabled]
    config.show_fields = [:title, :url, :rss, :last_fetched_at, :newswires_count, :user_id, :load_all, :is_blocked]
    config.new_fields = [:title, :url, :rss, :user_id, :load_all]
    config.edit_fields = [:title, :url, :rss, :user_id, :enabled, :load_all]
    config.actions = [:index, :new, :create, :update, :show, :edit]
    config.associations = { :belongs_to => { :user => :user_id } }
    config.index_links = [lambda { link_to 'Add Default Feeds', news_topics_admin_content_dashboard_path }]
  end

  def fetch_new
    @feed = Feed.enabled.active.find(params[:id])
    if @feed.async_update_feed
      flash[:success] = "Queued your feed for processing. Please wait a few minutes."
      redirect_to admin_feeds_path
    else
      flash[:error] = "Could not process your feed."
      redirect_to admin_feeds_path
    end
  end

  private

    def set_current_tab
      @current_tab = 'feeds';
    end

end
