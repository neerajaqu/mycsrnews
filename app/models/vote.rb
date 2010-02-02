class Vote < ActiveRecord::Base

  named_scope :for_voter,    lambda { |*args| {:conditions => ["voter_id = ? AND voter_type = ?", args.first.id, args.first.type.name]} }
  named_scope :for_voteable, lambda { |*args| {:conditions => ["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.type.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5)} }

  # NOTE: Votes belong to the "voteable" interface, and also to voters
  belongs_to :voteable, :polymorphic => true
  belongs_to :voter,    :polymorphic => true
  
  attr_accessible :vote, :voter, :voteable

  # Uncomment this to limit users to a single vote on each item. 
  # validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_type, :voter_id]

  after_create :update_user_karma

  private

  def update_user_karma
    user = voteable.user
    vote_value = vote ? 1 : -1
    user.karma_score += vote_value
    user.save
  end

end