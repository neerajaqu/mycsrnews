class FeedsWorker
  @queue = :feeds

  def self.perform(feed_id = nil)
    if feed_id
      N2::FeedParser.update_feed Feed.find(feed_id)
    else
      N2::FeedParser.update_feeds
    end
  end
    
end