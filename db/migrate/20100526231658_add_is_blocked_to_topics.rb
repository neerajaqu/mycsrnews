class AddIsBlockedToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :topics, :is_blocked
  end
end
