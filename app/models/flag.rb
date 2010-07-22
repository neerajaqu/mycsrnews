class Flag < ActiveRecord::Base
  belongs_to :user
  belongs_to :flaggable, :polymorphic => true, :counter_cache => true, :touch => true

  def self.flag_types
    ['spam', 'abuse', 'urgent', 'miscellaneous']
  end

  def self.valid_flag_type? flag_type
    self.flag_types.index(flag_type.downcase).nil? ? false : true
  end

  def item_title; flaggable.item_title; end
  def item_description; flaggable.item_description; end
  def is_blocked; flaggable.is_blocked; end
  def is_blocked?; flaggable.is_blocked?; end

  def num_flags
    flaggable.respond_to?(:flags_count) ? flaggable.flags_count : flaggable.flags.count
  end

end
