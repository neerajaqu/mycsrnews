class AddFeaturedAndSponsoredToResources < ActiveRecord::Migration
  def self.up
    add_column :resources, :is_featured, :boolean, :default => false
    add_column :resources, :featured_at, :datetime
    add_column :resources, :is_sponsored, :boolean, :default => false
  end

  def self.down
    remove_column :resources, :is_featured
    remove_column :resources, :featured_at
    remove_column :resources, :is_sponsored
  end
end
