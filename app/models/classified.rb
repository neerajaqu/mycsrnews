class Classified < ActiveRecord::Base
  include AASM

  acts_as_taggable_on :tags, :category, :subcategories, :location
  acts_as_voteable 
  acts_as_media_item

  acts_as_featured_item
  #acts_as_moderatable
  acts_as_relatable
  acts_as_wall_postable
  acts_as_tweetable
  
  named_scope :active
  named_scope :top, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :auto_expired, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :no_auto_expire, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state NOT IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :with_state, lambda { |*args| { :conditions => ["aasm_state = ?", args.first] } }

  belongs_to :user

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title, :details, :user_id

  before_save :set_expires_at

  aasm_initial_state :unpublished

# TODO:: ADD GUARDS
#   - loanable item should not be sellable
#   - sellable item should not be loanable
  aasm_state :unpublished
  aasm_state :available, :enter => [:expire, :set_published], :exit => :expire
  aasm_state :sold, :enter => :expire
  aasm_state :loaned_out, :enter => :expire
  aasm_state :expired, :enter => :expire
  aasm_state :closed, :enter => :expire
  aasm_state :hidden, :enter => :expire

  aasm_event :published do
    transitions :to => :available, :from => [:unpublished]
  end

  aasm_event :renewed do
    transitions :to => :available, :from => [:expired, :hidden], :success => :update_renewed
  end

  aasm_event :closed do
    transitions :to => :closed, :from => [:hidden, :available, :loaned_out]
  end

  aasm_event :sold do
    transitions :to => :sold, :from => :available
  end

  aasm_event :loaned_out do
    transitions :to => :loaned_out, :from => :available
  end

  aasm_event :hidden do
    transitions :to => :hidden, :from => [:available, :loaned_out]
  end

  aasm_event :returned do
    transitions :to => :hidden, :from => :loaned_out, :after => :update_renewed
  end

  aasm_event :expired do
    transitions :to => :expired, :from => [:unpublished, :available, :hidden]
  end

  def set_published; puts "Publishing" end
  def set_unpublish; puts "Publishing" end
  def update_renewed; puts "Renewed" end
  def expire; puts "Expiring" end
  def loan_to! user
    # create loaning
    loaned_out!
  end
  def state() aasm_current_state end

  def sellable?; true end
  def loanable?; true end

  def unhide!
    # notify waiting list users
    renewed!
  end
  
  def comments_count
    0
  end

  def votes_tally
    votes_count
  end
  
  def votes_count
    0
  end

  def has_expired?
    Time.now > expires_at
  end

  def self.auto_expire_all
    self.auto_expired.each {|c| c.expired! }
  end
  
  private
    
    def set_expires_at
      self.expires_at ||= 2.weeks.from_now
    end
end
