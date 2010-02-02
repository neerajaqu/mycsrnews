class FeaturedItem < ActiveRecord::Base
  acts_as_tree
  belongs_to :featurable, :polymorphic => true

  def featured_item?
    self.featurable.present?
  end

  def root?
    self.parent_id.nil?
  end

  def self.find_root_by_item_name(name)
    self.find(:all, :conditions => ["parent_id IS NULL and name = ?", name]).first
  end
end
