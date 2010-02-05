class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :flagable, :polymorphic => true, :counter_cache => true
end
