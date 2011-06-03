class AddNewswiresCountToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :newswires_count, :integer, :default => 0
  end

  def self.down
    remove_column :feeds, :newswires_count
  end
end
