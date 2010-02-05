class AddBlockedToIdeas < ActiveRecord::Migration
  def self.up
    add_column  :ideas, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :ideas, :is_blocked
  end
end
