PfeedItem.class_eval do

  def self.expire
    self.class.sweeper.expire_pfeed_all self
  end

  def self.sweeper
    PfeedSweeper
  end

  def self.newest_items limit = 5
    self.active.find(:all, :conditions => ["participant_type IN ('#{self.item_klasses.join "', '"}')"], :limit => limit, :order => "created_at desc").map(&:participant)
  end

end
