class Classified < ActiveRecord::Base
  include AASM

  acts_as_authorization_object

  acts_as_taggable_on :tags, :location
  acts_as_voteable 
  acts_as_media_item

  acts_as_categorizable
  acts_as_featured_item
  acts_as_moderatable
  acts_as_relatable
  acts_as_wall_postable
  acts_as_tweetable
  
  named_scope :top, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :auto_expired, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :no_auto_expire, lambda { |*args| { :conditions => ["expires_at < ? AND aasm_state NOT IN (?)", Time.zone.now, [:unpublished, :available, :hidden].map(&:to_s)] } }
  named_scope :with_state, lambda { |*args| { :conditions => ["aasm_state = ?", args.first] } }
  named_scope :for_sale, { :conditions => ["listing_type = ?", "sale"] }
  named_scope :for_free, { :conditions => ["listing_type = ?", "free"] }
  named_scope :for_loan, { :conditions => ["listing_type = ?", "loan"] }
  named_scope :allow_all, { :conditions => ["allow = ?", "all"] }
  named_scope :allow_friends, { :conditions => ["allow = ?", "friends"] }
  named_scope :allow_friends_of_friends, { :conditions => ["allow = ?", "friends_of_friends"] }
  named_scope :available, { :conditions => ["aasm_state = ?", "available"] }
  named_scope :search_on, lambda { |keyword| { :conditions => ["title LIKE ? OR details LIKE ?", "%#{keyword}%", "%#{keyword}%"] } }
  named_scope :in_category, lambda { |category_id|
    return {} if category_id.nil?
    { :conditions => ["id IN (SELECT categorizable_id FROM categorizations WHERE categorizable_type = ? AND category_id = ?)", self.name, category_id] }
  }

  belongs_to :user

  has_friendly_id :title, :use_slug => true
  has_many :comments, :as => :commentable

  validates_presence_of :title, :details, :user_id

  validate :validate_listing_type
  validate :validate_allow_type

  before_save :set_expires_at

  after_create :save_to_redis

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
  
  def has_expired?
    Time.now > expires_at
  end

  def self.auto_expire_all
    self.auto_expired.each {|c| c.expired! }
  end

  def self.listing_types
    #[:sale, :free, :loan, :wanted]
    [:sale, :free, :loan]
  end

  def valid_listing_type?
    self.class.valid_listing_type? listing_type
  end

  def self.valid_listing_type? type
    return false unless type
    self.listing_types.include? type.to_sym
  end
  
  def self.allow_types
    [:all, :friends, :friends_of_friends]
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

  def valid_user_events
    events = aasm_events_for_current_state

    events.delete :expired
    events.delete :sold if loanable?
    events.delete :loaned_out if sellable? or free?

    events
  end

  def allow_type() allow.to_sym end
  def allow_type=(atype) self.allow = atype end

  def self.filtered_results options, user = nil
    keyword = options['keyword'].present? ? options['keyword'] : nil

    user_sets = self.sets_for_user(user)

    chains = []

    chains << [:in_category, options['categories']] if options['categories'] =~ /^[0-9]+$/

    case options['allow_type']
    when 'all'
      chains << :allow_all
    when 'friends'
      chains << :allow_friends
    when 'friends_of_friends'
      chains << :allow_friends_of_friends
    else
    end

    case options['listing_type']
    when 'free'
      chains << :for_free
    when 'sale'
      chains << :for_sale
    when 'loan'
      chains << :for_loan
    else
    end

    if keyword
    	chains << [:search_on, keyword]
    end

    chains << :newest

    results = chains.inject(self) do |chain, scope|
      if scope.is_a? Array
      	chain.send scope[0], scope[1]
      else
      	chain.send scope
      end
    end

    results.find(:all, :conditions => ["id IN (?)", $redis.sunion(*user_sets)])
  end

=begin
  def recipient_voices
    users = self.voices
    users << self.commentable.user
    # get list of people who liked commentable item
    users.concat self.commentable.votes.map(&:voter) 
    users.delete self.user
    users.uniq
  end
=end

  def self.for_user user = nil
    sets = sets_for_user(user)
    self.available.active.find(:all, :conditions => ["id IN (?)", $redis.sunion(*sets)], :order => "created_at desc")
  end

  def self.sets_for_user user = nil
    sets = ["items:classifieds:public:free", "items:classifieds:public:sale"]
    if user
    	sets.push "items:classifieds:public:loan"
    	sets = sets | $redis.smembers("#{user.cache_id}:friends").map {|f| "user:#{f}:items:classifieds:friends"}
    end
    sets
  end

  def expire
    self.class.sweeper.expire_classified_all self
  end

  def self.expire_all
    self.sweeper.expire_classified_all self.new
  end

  def self.sweeper
    ClassifiedSweeper
  end

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
    
    def self.default_tags(options = {})
      conditions = {
        :context       => (options[:on] || "tags").to_s,
        :taggable_type => self.name,
        :taggable_id   => nil
      }
      Tagging.find(:all, :include => :tag, :conditions => conditions).map(&:tag).uniq
    end

    def self.build_default_tag_on(tag_name, context = "tags")
      return true if self.default_tags(:on => context).map(&:name).include? tag_name.to_s
      tag = Tag.find_or_create_by_name(tag_name.to_s)
      if tag
      	Tagging.create!({
          :context       => context,
          :taggable_type => self.name,
          :taggable_id   => nil,
          :tag           => tag
        })
      end
    end

    def set_expires_at
      self.expires_at ||= 2.weeks.from_now
    end

    def validate_listing_type
      errors.add(:listing_type, "must be a valid listing type") unless self.valid_listing_type?
    end

    def validate_allow_type
      errors.add(:allow, "must be a valid allow group") unless self.valid_allow_type?
    end

    def save_to_redis
      $redis.sadd "user:#{user_id}:items:classifieds:#{allow}", id
      $redis.sadd "items:classifieds:public:#{listing_type}", id if allow == 'all'
    end
end
