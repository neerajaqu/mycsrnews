class AddForumFields < ActiveRecord::Migration
  def self.up
    add_column :users, :posts_count, :integer, :default => 0

    add_index :users, :posts_count

    add_index :comments, :commentable_type
  end

  def self.down
    remove_index  :users, :posts_count
    remove_column :users, :posts_count
    remove_index  :comments, :commentable_type
  end
end
