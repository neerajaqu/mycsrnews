require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  acts_as_authorization_subject
  has_and_belongs_to_many :roles

  acts_as_voter
  acts_as_moderatable

  #named_scope :top, lambda { |*args| { :order => ["karma_score desc"], :limit => (args.first || 5), :conditions => ["karma_score > 0 and is_admin = 0 and is_editor=0"]} }
  named_scope :top, lambda { |*args| { :order => ["karma_score desc"], :limit => (args.first || 5), :conditions => ["karma_score > 0"]} }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5), :conditions => ["created_at > ?", 2.months.ago]} }
  named_scope :last_active, lambda { { :conditions => ["last_active > ?", 60.minutes.ago], :order => ["last_active desc"] } }
  named_scope :recently_active, lambda { |*args| { :order => ["last_active desc"], :limit => (args.first || 21) } }
  named_scope :admins, { :conditions => ["is_admin is true"] } 
  named_scope :moderators, { :conditions => ["is_moderator is true"] }
  named_scope :members, { :conditions => ["is_moderator is false and is_admin is false and is_editor is false and is_host is false"] }

  validates_presence_of     :login, :unless => :facebook_connect_user?
  validates_length_of       :login,    :within => 3..40, :unless => :facebook_connect_user?
  validates_uniqueness_of   :login, :unless => :facebook_connect_user?
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message, :unless => :facebook_connect_user?

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email, :unless => :facebook_connect_user?
  validates_length_of       :email,    :within => 6..100, :unless => :facebook_connect_user? #r@a.wk
  validates_uniqueness_of   :email, :unless => :facebook_connect_user?
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :unless => :facebook_connect_user?
  
  # TODO::HACK:: fb registration errors
  # TODO::REMOVE:: deprecated: http://developers.facebook.com/docs/reference/rest/connect.registerusers/
  #after_create :register_user_to_fb, :if => Proc.new { Rails.env.production? }
  before_save :check_profile
  
  has_many :contents, :after_add => :trigger_story
  has_many :articles, :foreign_key => :author_id, :after_add => :trigger_article
  has_many :comments
  has_many :related_items
  has_many :messages
  has_many :received_chirps, :class_name => "Chirp", :foreign_key => 'recipient_id'
  has_many :sent_chirps, :class_name => "Chirp", :foreign_key => 'user_id', :after_add => :trigger_chirp
  has_many :activities, :class_name => "PfeedItem", :as => :originator, :order => "created_at desc", :conditions => ["participant_type != ?", Chirp.name]
  has_many :questions, :after_add => :trigger_question
  has_many :answers, :after_add => :trigger_answer
  has_many :ideas, :after_add => :trigger_idea
  has_many :classifieds, :after_add => :trigger_classified
  has_many :events, :after_add => :trigger_event
  has_many :resources, :after_add => :trigger_resource
  #has_many :topics, :after_add => :trigger_topic
  has_many :topics
  has_many :dashboard_messages, :after_add => :trigger_dashboard_message
  has_one :profile, :class_name => "UserProfile"
  has_one :user_profile #TODO:: convert views and remove this
  has_many :received_cards, :class_name => "SentCard", :foreign_key => 'to_fb_user_id', :primary_key => 'fb_user_id', :conditions => 'sent_cards.to_fb_user_id IS NOT NULL'
  has_many :sent_cards, :class_name => "SentCard", :foreign_key => 'from_user_id'
  has_one  :twitter,:class_name=>"TwitterToken", :dependent=>:destroy
  has_many :prediction_groups
  has_many :prediction_questions
  has_many :prediction_guesses
  has_many :galleries, :after_add => :trigger_gallery
  has_many :gallery_items
  has_many :prediction_results
  has_one :prediction_score

  belongs_to :last_viewed_feed_item, :class_name => "PfeedItem", :foreign_key => "last_viewed_feed_item_id"
  belongs_to :last_delivered_feed_item, :class_name => "PfeedItem", :foreign_key => "last_delivered_feed_item_id"
  
  has_karma :contents

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # NOTE:: this must be above has_friendly_id, see below
  attr_accessible :login, :email, :name, :password, :password_confirmation, :karma_score, :is_admin, :is_blocked, :cached_slug, :is_moderator, :is_editor, :is_host

  accepts_nested_attributes_for :user_profile

  # NOTE NOTE NOTE NOTE NOTE
  # friendly_id uses attr_protected!!!
  # and you can't use both attr_accessible and attr_protected
  # so... this line MUST be located beneath attr_accessible or your get runtime errors
  has_friendly_id :name, :use_slug => true, :reserved => RESERVED_NAMES


  # FB Graph API settings
  delegate :post_comments?, :to => :user_profile
  delegate :post_likes?, :to => :user_profile
  delegate :post_items?, :to => :user_profile

  # NOTE:: must be above emits_pfeeds call
  def trigger_comment(comment) end
  def trigger_article(article) end
  def trigger_story(story) end
  #def trigger_topic(topic) end
  def trigger_question(question) end
  def trigger_answer(answer) end
  def trigger_idea(idea) end
  def trigger_classified(classified) end
  def trigger_event(event) end
  def trigger_resource(resource) end
  def trigger_dashboard_message(dashboard_message) end
  def trigger_chirp(chirp) end
  def trigger_gallery(gallery) end
  #def trigger_accepted_prediction_question(prediction_question) end
  
  def pfeed_trigger_delivery_callback(pfeed_item)
    self.update_attribute(:last_delivered_feed_item, pfeed_item)
  end

  def pfeed_inbox_unread limit = 3
    return pfeed_inbox.find(:all, :limit => limit) unless last_viewed_feed_item
    pfeed_inbox.newer_than(last_viewed_feed_item).find(:all, :limit => limit)
  end

  def pfeed_inbox_get_new!
    items = pfeed_inbox_unread
    pfeed_set_last_viewed! items.last
    items
  end

  def pfeed_set_last_viewed! pfeed_item
    #return true if last_viewed_feed_item == last_delivered_feed_item and last_delivered_feed_item.id > pfeed_item.id
    return true if last_viewed_feed_item == last_delivered_feed_item
    self.update_attribute(:last_viewed_feed_item, pfeed_item)
  end

  def pfeed_set_last_viewed_as_delivered!
    return true if last_viewed_feed_item == last_delivered_feed_item
    self.update_attribute(:last_viewed_feed_item, last_delivered_feed_item)
  end

  emits_pfeeds :on => [:trigger_story], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_article], :for => [:friends], :identified_by => :name
  #emits_pfeeds :on => [:trigger_topic], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_question], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_answer], :for => [:participant_recipient_voices, :friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_idea], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_classified], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_event], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_gallery], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_resource], :for => [:friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_dashboard_message], :for => [:participant_recipient_voices], :identified_by => :name
  emits_pfeeds :on => [:trigger_comment], :for => [:participant_recipient_voices, :friends], :identified_by => :name
  emits_pfeeds :on => [:trigger_chirp], :for => [:participant_recipient], :identified_by => :name
  #emits_pfeeds :on => [:trigger_accepted_prediction_question], :for => [:participant_recipient_voices, :friends], :identified_by => :name
  receives_pfeed


  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end

  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    new_facebooker = User.new(:name => fb_user.name, :login => "facebooker_#{fb_user.uid}", :password => "", :email => "")
    new_facebooker.fb_user_id = fb_user.uid.to_i
    #We need to save without validations
    new_facebooker.save(false)
    #new_facebooker.register_user_to_fb
  end

  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save(false)
      end
      #link the new one
      self.fb_user_id = fb_user_id
      save(false)
    end
  end

  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    r = Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save(false)
  end

  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end

  def accepts_email_notifications?
    self.email.present? and self.user_profile.receive_email_notifications == true
  end
  
# TODO:: Update this
  def friends
    []
  end

  def friends_with? user
    redis_friend_ids.include? user
  end

  def friends_of_friends_with? user
    # TODO:: add this
    friends_with? user
  end

  def fb_user_id
    return super unless super.nil?
    return nil unless self.user_profile.present?
    return self.user_profile.facebook_user_id unless self.user_profile.facebook_user_id.nil? or self.user_profile.facebook_user_id.zero?

    nil
  end

  def facebook_id
    fb_user_id
  end

  # Taken from vendor/plugins/restful_authentication/lib/authentication/by_password.rb
  # We need to add the check to ignore password validations if using facebook connect
  def password_required?
    # Skip password validations if facebook connect user
    return false if facebook_connect_user?
    crypted_password.blank? || !password.blank?
  end

  # Skip password validations if facebook connect user
  def facebook_connect_user?
    facebook_user? and password.blank?
  end

  def other_posts
    self.contents.find(:all, :conditions => ["article_id is null"], :limit => 7, :order => "created_at desc")
  end
  
  def other_stories curr_story
    self.contents.find(:all, :conditions => ["id != ?", curr_story.id], :limit => 7, :order => "created_at desc")
  end

  def is_admin?
    self.is_admin == true
  end

  def is_editor?
    self.is_editor == true
  end

  def is_moderator?
    # admins have all powers of moderators
    (self.is_moderator || self.is_editor || self.is_admin) == true
  end

  def is_host?
    self.is_host == true
  end
  
  def is_established?
    # returning user after two weeks
    (self.created_at < 2.week.ago) == true
  end

  def bio
    self.user_profile.present? ? self.user_profile.bio : nil
  end

  def newest_actions
    actions = self.votes.newest | self.comments.newest | self.contents.newest
    actions.sort_by {|a| a.created_at}.reverse[0,10]
  end

# TODO:: move this to a setting
  def public_name
    firstnameonly = Metadata::Setting.find_setting('firstnameonly').try(:value) || false
    return self.name.split(' ').first if firstnameonly
    self.name
  end

  def to_s
    "#{self.name}"
  end

  def combined_score
    self.activity_score + self.karma_score
  end
  
  def add_score! score
    case score.score_type
      when "participation"
        field = :activity_score
      when "karma"
        field = :karma_score
      else
        field = nil
    end
    increment!(field, score.value) unless field.nil?
  end
  
  def is_blogger?
    self.articles.count > 0
  end
  
  def count_daily_posts
    self.contents.find(:all, :conditions => ["created_at > ?", 24.hours.ago]).count
  end

  def fb_oauth_active?
    fb_oauth_key.present? and fb_oauth_denied_at.nil?
  end

  def fb_oauth_desired?
    fb_oauth_key.nil? and fb_oauth_denied_at.nil?
  end

  def expire
    self.class.sweeper.expire_user_all self
  end

  def self.expire_all
    self.sweeper.expire_user_all self.new
  end

  def self.sweeper
    UserSweeper
  end

  def get_prediction_score
    return self.prediction_score unless self.prediction_score.nil?
    prediction_score = self.build_prediction_score
    prediction_score.save ? prediction_score : nil
  end

  def mogli_user
    return nil unless fb_oauth_active?
    @mogli_user ||= Mogli::User.find("me", mogli_client)
  end
  
  def mogli_friends
    return [] unless mogli_user

    mogli_user.friends
  end

  def facebook_friends
    return [] unless mogli_user

    mogli_friends.map {|f| User.find_by_fb_user_id(f.id) }.compact
  end
  
  def facebook_friend_ids
    return [] unless mogli_user

    mogli_friends.map {|f| User.find_by_fb_user_id(f.id, :select => "id").try(:id) }.compact
  end
  
  # Overload has_role? from ACL9 to delegate access to given model
  def has_role?(role_name, object = nil)
    method = "is_#{role_name.to_s}?".to_sym

    !! if object.nil? and ( self.roles.find_by_name(role_name.to_s) || self.roles.member?(get_role(role_name, nil)) )
      true
    elsif method == :is_admin?
      self.is_admin?
    elsif object.respond_to?(method)
    	  object.send(method, self)
    else
      role = get_role(role_name, object)
      role && self.roles.exists?(role.id)
    end
  end

  #
  # REDIS FUNCTIONS
  #
  def redis_update_friends friends_string
    friends = friend_ids friends_string.split(',')
    $redis.multi do
      friends.each {|f| $redis.sadd "#{self.cache_id}:friends", f }
    end
  end

  def redis_friends friends_array = nil
    friends_array ||= $redis.smembers "#{self.cache_id}:friends"
    User.find(:all, :conditions => ["ID IN (?)", friends_array])
  end

  def redis_friend_ids
    $redis.smembers "#{self.cache_id}:friends"
  end

  def friend_ids friends_array = []
    User.find(:all, :select => "id", :conditions => ["fb_user_id IN (?)", friends_array]).map(&:id)
  end

  private

  def mogli_client
    @mogli_client ||= Mogli::Client.new fb_oauth_key
  end

  def check_profile
    self.build_profile if self.profile.nil?
  end

  protected
    


end
