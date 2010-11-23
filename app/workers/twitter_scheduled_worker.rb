class TwitterScheduledWorker
  @queue = :twitter_scheduled

  def self.perform
    Newscloud::Tweeter.new.tweet_hot_items
  end

end
