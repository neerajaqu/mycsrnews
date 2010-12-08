class SentCard < ActiveRecord::Base
  acts_as_moderatable


  belongs_to :card
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_fb_user_id", :primary_key => 'fb_user_id'

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :sent_by, lambda { |*args| { :conditions => ["from_user_id = ?", args.first] } }

  def self.top limit = 5
    self.find(:all, :group => 'card_id', :select => 'card_id, count(card_id) as card_count', :order => 'card_count desc', :limit => limit)
  end

  def expire
    self.card.expire
  end

  def self.expire_all
    Card.expire_all
  end

end
