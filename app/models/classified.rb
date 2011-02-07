class Classified < ActiveRecord::Base
  include AASM

  acts_as_authorization_object

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
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :auto_expired, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :no_auto_expire, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state NOT IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :with_state, lambda { |*args| { :conditions => ["aasm_state = ?", args.first] } }

  belongs_to :user

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title, :details, :user_id

  validate :validate_listing_type
  validate :validate_allow_type

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

  def sellable?; listing_type == "sale" end
  def loanable?; listing_type == "loan" end
  def wanted?; listing_type == "wanted" end
  def free?; listing_type == "free" end

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

  def self.listing_types
    [:free, :sale, :loan, :wanted]
  end

  def valid_listing_type?
    self.class.valid_listing_type? listing_type
  end

  def self.valid_listing_type? type
    return false unless type
    self.listing_types.include? type.to_sym
  end
  
  def self.allow_types
    [:friends, :friends_of_friends, :all]
  end

  def valid_allow_type?
    self.class.valid_allow_type? allow
  end

  def self.valid_allow_type? type
    return false unless type
    self.allow_types.include? type.to_sym
  end
  
  def is_owner? user
    user == self.user
  end

  def is_allowed? user = nil
    return true if is_owner? user

    method = "__#{state.to_s}_is_allowed?".to_sym

    if respond_to?(method)
    	send(method, user)
    else
    	false
    end
  end

  def allow_type() allow.to_sym end
  def allow_type=(atype) self.allow = atype end

  protected
    #
    # STATE METHODS
    # Should be of the form __STATE__#{overloaded_method_name}
    #
    def allow_user? user = nil, opts = {}
      return false if opts[:require_user] and not user

      default = opts[:default].present? ? opts[:default] : false
      default_all = opts[:default_all].present? ? opts[:default_all] : true

      case allow_type
      when :all
        default_all
      when :friends
        !! user and user.friends_with? self.user
      when :friends_of_friends
        !! user and user.friends_of_friends_with? self.user
      else
        default
      end
    end

    def __unpublished_is_allowed?(user = nil)
      user == self.user
    end

    def __hidden_is_allowed?(user = nil)
      user == self.user
    end

    def __loaned_out_is_allowed?(user = nil)
      allow_user? user, :require_user => true
    end

    def __expired_is_allowed?(user = nil)
      allow_user? user, :require_user => loanable?
    end

    def __sold_is_allowed?(user = nil)
      allow_user? user
    end

    def __closed_is_allowed?(user = nil)
      allow_user? user, :require_user => loanable?
    end

    def __available_is_allowed?(user = nil)
      # TODO::: REFACTOR
      if free? or sellable?
        allow_user? user, :default => true
      elsif loanable?
        allow_user? user, :require_user => true, :default => false
      else
      	false
      end
    end

  private
    
    def set_expires_at
      self.expires_at ||= 2.weeks.from_now
    end

    def validate_listing_type
      errors.add(:listing_type, "must be a valid listing type") unless self.valid_listing_type?
    end

    def validate_allow_type
      errors.add(:allow, "must be a valid allow group") unless self.valid_allow_type?
    end

end
