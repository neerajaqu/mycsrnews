class AddEnabledToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :enabled, :boolean, :default => true

    add_index :feeds, :enabled
  end

  def self.down
    remove_column :feeds, :enabled

    remove_index :feeds, :enabled
  end
end
