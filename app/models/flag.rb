class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :flaggable, :polymorphic => true, :counter_cache => true, :touch => true

  def self.flag_types
    ['spam', 'abuse', 'urgent', 'other']
  end

  def self.valid_flag_type? flag_type
    self.flag_types.index(flag_type.downcase).nil? ? false : true
  end

end
