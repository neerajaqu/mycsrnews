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

  # ::HACK::
  # !!!THIS WILL NOT WORK!!!
  # This model is first loaded in the vote_fu plugin _before_ the lib
  # extensions have been loaded, so it will blow up.
  # To get around this, we are doing Vote.send(:acts_as_scorable) in
  # the libraries initializer
  #
  #acts_as_scorable

  # Uncomment this to limit users to a single vote on each item. 
  # validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_type, :voter_id]

  after_save :update_voteable_count

  def async_vote_messenger item_url, app_caption, image_url = nil
    Resque.enqueue(VoteMessenger, id, item_url, app_caption, image_url) if voter.fb_oauth_active?
  end

  def self.top_items limit = 5, range = nil, min_items = nil
    # HACK:: TODO:: FIXME
    # When this gets run through Metadata::ViewObjectSetting.kommand_chain
    # something like [3,nil,3] will get flattened to [3,3] which is obviously not right
    if range.is_a?(Integer) and min_items.nil?
      min_items = range
      range = nil
    end

    range ||= 1.week.ago
    items = self.active.find(:all, :select => 'count(*) as count, votes.*', :group => 'voteable_type, voteable_id', :conditions => ["voteable_type IN ('#{self.item_klasses.join "', '"}') AND created_at > ?", range], :limit => limit, :order => "count desc, created_at desc").map(&:voteable)
    if items.any? and (not min_items or items.count >= min_items)
    	items
    else
      items = self.active.find(:all, :select => 'count(*) as count, votes.*', :group => 'voteable_type, voteable_id', :conditions => ["voteable_type IN ('#{self.item_klasses.join "', '"}')"], :limit => limit, :order => "count desc, created_at desc").map(&:voteable)
    end
  end

  private

  def update_voteable_count
    vote_value = vote ? 1 : -1
    if voteable.votes_tally == nil
      voteable.votes_tally = 0
    end
    voteable.votes_tally += vote_value
    voteable.save
    return false # return false to prevent additional triggers of this method
  end

  def model_score_name
    "item_vote"
  end

  def scorable_user
    voteable.user
  end

end