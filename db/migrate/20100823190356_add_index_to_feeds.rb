class AddIndexToFeeds < ActiveRecord::Migration
  def self.up
    add_index :feeds, :deleted_at
  end

  def self.down
    remove_index :feeds, :deleted_at
  end
end
