class AddLoadAllToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :load_all, :boolean, :default => false
  end

  def self.down
    remove_column :feeds, :load_all
  end
end
