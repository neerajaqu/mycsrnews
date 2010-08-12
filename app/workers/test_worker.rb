class TestWorker
  @queue = :test

  def self.perform(foo, bar)
    Rails.logger.debug("****RAN TEST WORKER****")
    #Rails.logger.debug.flush
  end
end
