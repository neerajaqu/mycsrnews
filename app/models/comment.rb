class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true, :counter_cache => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 5)} }
end
