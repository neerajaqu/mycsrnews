class Comment < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable
  acts_as_refineable

  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true, :touch => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["featured_at desc"], :limit => (args.first || 1)} }
#  named_scope :controversial, lambda { |*args| { :order => ["??? desc"], :limit => (args.first || 10)} }

  validates_presence_of :comments

  after_create :custom_callback
  attr_accessor :post_wall

  def post_wall?
    post_wall and post_wall.to_i != 0
  end
  
  def item_title
    "Comment on #{self.commentable.item_title}"
  end

  def item_description
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

  private

  def custom_callback
    self.commentable.comments_callback if self.commentable.respond_to?(:comments_callback)
  end

end
