class Topic < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable

  has_many :posts, :class_name => "Comment", :as => :commentable
  has_many :comments, :as => :commentable
  has_many :voices, :through => :posts, :source => :user
  has_one :last_post, :class_name => "Comment"
  belongs_to :user
  belongs_to :replied_user, :class_name => "User"
  belongs_to :forum, :counter_cache => true, :touch => true

  has_friendly_id :title, :use_slug => true

  validates_presence_of :forum, :user, :title
  validates_presence_of :body, :if => :new_record?

  named_scope :newest, lambda { |*args| { :order => ["replied_at desc"], :limit => (args.first || 5)} }
  named_scope :top, lambda { |*args| { :order => ["comments_count desc, created_at desc"], :limit => (args.first || 5)} }

  attr_accessor :body, :tags_string

  def item_description
    return self.posts.first.comments if self.posts.any?
    "No topic description yet"
  end

  def last_post
    self.posts.last
  end

  def voices_count
    self.voices.uniq.size
  end

  def crumb_parents
    [self.forum.crumb_items].flatten
  end

  def crumb_link
    [self.forum, self]
  end

  def viewed!
    Topic.increment_counter(:views_count, self.id)
  end

  def comments_callback
    Forum.increment_counter(:comments_count, self.forum.id)

    last_post = posts.last

    self.replied_at = last_post.created_at
    self.replied_user = last_post.user
    self.last_comment_id = last_post.id

    save!

    ForumSweeper.expire_topic_all self
  end

end
