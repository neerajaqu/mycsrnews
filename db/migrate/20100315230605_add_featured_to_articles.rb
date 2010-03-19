class AddFeaturedToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :is_featured, :boolean, :default => false
    add_column :articles, :featured_at, :datetime
  end

  def self.down
    remove_column :articles, :is_featured
    remove_column :articles, :featured_at
  end
end
