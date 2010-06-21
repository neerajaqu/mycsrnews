class AddLastFeedPointersToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_viewed_feed_item_id, :integer
    add_column :users, :last_delivered_feed_item_id, :integer
  end

  def self.down
  end
end
