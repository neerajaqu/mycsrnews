class AddLikesCountToComments < ActiveRecord::Migration
  def self.up
    add_column  :comments, :likes_count, :integer, :default => 0
  end

  def self.down
    remove_column :comments, :likes_count
  end
end
