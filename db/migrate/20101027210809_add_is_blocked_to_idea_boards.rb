class AddIsBlockedToIdeaBoards < ActiveRecord::Migration
  def self.up
    add_column :idea_boards, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :idea_boards, :is_blocked
  end
end
