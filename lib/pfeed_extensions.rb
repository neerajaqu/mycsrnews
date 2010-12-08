PfeedItem.class_eval do

  def expire
    self.class.sweeper.expire_pfeed_all self
  end

  def self.sweeper
    PfeedSweeper
  end

end
