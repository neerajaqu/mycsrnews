require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  acts_as_voter

  named_scope :top, lambda { |*args| { :order => ["karma_score desc"], :limit => (args.first || 5), :conditions => ["karma_score > 0 and is_admin = 0"]} }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5), :conditions => ["created_at > ?", 2.months.ago]} }
  named_scope :last_active, lambda { { :conditions => ["last_active > ?", 5.minutes.ago], :order => ["last_active desc"] } }
  named_scope :admins, { :conditions => ["is_admin is true"] }
  named_scope :moderators, { :conditions => ["is_moderator is true"] }

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

  after_create :register_user_to_fb
  before_save :check_profile
  
  has_many :contents
  has_many :comments
  has_many :messages
  has_many :ideas
  has_many :questions
  has_many :answers
  has_many :events
  has_many :resources
  has_one :profile, :class_name => "UserProfile"
  has_one :user_profile #TODO:: convert views and remove this
  has_many :received_cards, :class_name => "SentCard", :foreign_key => 'to_fb_user_id', :primary_key => 'fb_user_id', :conditions => 'sent_cards.to_fb_user_id IS NOT NULL'
  has_many :sent_cards, :class_name => "SentCard", :foreign_key => 'from_user_id'

  has_karma :contents

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # NOTE:: this must be above has_friendly_id, see below
  attr_accessible :login, :email, :name, :password, :password_confirmation, :karma_score, :is_admin, :is_blocked, :cached_slug, :is_moderator?


  # NOTE NOTE NOTE NOTE NOTE
  # friendly_id uses attr_protected!!!
  # and you can't use both attr_accessible and attr_protected
  # so... this line MUST be located beneath attr_accessible or your get runtime errors
  has_friendly_id :name, :use_slug => true, :reserved => RESERVED_NAMES


  


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
    new_facebooker.register_user_to_fb
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

  def fb_user_id
    return super unless super.nil?
    return nil unless self.user_profile.present?
    return self.user_profile.facebook_user_id unless self.user_profile.facebook_user_id.nil?

    nil
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

  def facebook_id
    fb_user_id
  end

  def other_stories curr_story
    self.contents.find(:all, :conditions => ["id != ?", curr_story.id], :limit => 10, :order => "created_at desc")
  end

  def is_admin?
    self.is_admin == true
  end

  def is_moderator?
    # admins have all powers of moderators
    (self.is_moderator || self.is_admin) == true
  end

  def bio
    self.user_profile.present? ? self.user_profile.bio : nil
  end

  def newest_actions
    actions = self.votes.newest | self.comments.newest | self.contents.newest
    actions.sort_by {|a| a.created_at}.reverse[0,10]
  end

  def to_s
    "User: #{self.name}"
  end

  def self.find_admin_users
    User.find(:all, :conditions => ['is_admin = true'])
  end

  private

  def check_profile
    self.build_profile if self.profile.nil?
  end

  protected
    


end
