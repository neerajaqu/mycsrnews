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

  def item_title
    "Comment on #{self.commentable.item_title}"
  end

  def downvoteable?
    true
  end
end
