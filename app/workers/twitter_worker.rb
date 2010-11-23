class TwitterWorker
  @queue = :twitter

  def self.perform(klass, id)
    item = klass.constantize.find(id)
    return false unless item

    tweeter = Newscloud::Tweeter.new
    tweeter.tweet_item item
  end
end
