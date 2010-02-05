class AddFeaturedToIdeas < ActiveRecord::Migration
  def self.up
    add_column :ideas, :is_featured, :boolean, :default => false
    add_column :ideas, :featured_at, :datetime
  end

  def self.down
    remove_column :ideas, :is_featured
    remove_column :ideas, :featured_at
  end
end
