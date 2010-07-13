class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :scorable, :polymorphic => true

  named_scope :for_user, lambda { |*args| { :conditions => ["user_id = ?", args.first], :order => ["created_at desc"] } }

end
