class AddFeaturedToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_featured, :boolean, :default => false
    add_column :comments, :featured_at, :datetime
  end

  def self.down
    remove_column :comments, :is_featured
    remove_column :comments, :featured_at
  end
end
