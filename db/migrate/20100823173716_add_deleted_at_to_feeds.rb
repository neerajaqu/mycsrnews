class AddDeletedAtToFeeds < ActiveRecord::Migration
  def self.up
    add_column  :feeds, :deleted_at, :datetime, :default => nil
  end

  def self.down
    remove_column :feeds, :deleted_at
  end
end
