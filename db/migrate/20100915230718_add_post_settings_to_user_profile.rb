class AddPostSettingsToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :post_comments, :boolean, :default => true
    add_column :user_profiles, :post_likes, :boolean, :default => true
    add_column :user_profiles, :post_items, :boolean, :default => true
  end

  def self.down
    remove_column :user_profiles, :post_comments
    remove_column :user_profiles, :post_likes
    remove_column :user_profiles, :post_items
  end
end
