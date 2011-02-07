class AddIsBlockedToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :votes, :is_blocked
  end
end
