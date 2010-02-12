class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :flagable, :polymorphic => true, :counter_cache => true

  def self.flag_types
    ['spam', 'inappropriate', 'other']
  end

  def self.valid_flag_type? flag_type
    self.flag_types.index(flag_type.downcase).nil? ? false : true
  end

end
