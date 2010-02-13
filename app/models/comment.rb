class Comment < ActiveRecord::Base
  acts_as_voteable
  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  named_scope :active, { :conditions => ["is_blocked = 0"] }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }
  validates_presence_of :comments
end
