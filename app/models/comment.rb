class Comment < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable
  acts_as_refineable
  acts_as_wall_postable

  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true, :touch => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["featured_at desc"], :limit => (args.first || 1)} }
#  named_scope :controversial, lambda { |*args| { :order => ["??? desc"], :limit => (args.first || 10)} }

  validates_presence_of :comments

  after_create :custom_callback
  after_create :trigger_user_comment

  def voices
    Comment.find(:all, :include => :user, :group => :user_id, :conditions => {:commentable_type => self.commentable_type, :commentable_id => self.commentable_id}).map(&:user)
  end

  def recipient_voices
    users = self.voices
    users << self.commentable.user
    # get list of people who liked commentable item
    users.concat self.commentable.votes.map(&:voter) 
    users.delete self.user
    users.uniq
  end

  def item_title
    "Comment on #{self.commentable.item_title}"
  end

  def item_description
    self.commentable.item_description
  end
  
  def wall_caption
    self.comments
  end

  def item_link
    self.commentable
  end
  
  def downvoteable?
    true
  end

  def forum_post?
    self.commentable_type == 'Topic'
  end

  def crumb_parents
    [self.commentable.crumb_items].flatten
  end

  def async_comment_messenger item_url, app_caption, image_url = nil
    Resque.enqueue(CommentMessenger, id, item_url, app_caption, image_url) if user.fb_oauth_active?
  end

  private

  def custom_callback
    self.commentable.comments_callback if self.commentable.respond_to?(:comments_callback)
  end

  def trigger_user_comment
    self.user.trigger_comment(self)
  end

end
