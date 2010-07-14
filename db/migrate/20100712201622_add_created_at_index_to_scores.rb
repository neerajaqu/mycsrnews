class AddCreatedAtIndexToScores < ActiveRecord::Migration
  def self.up
    add_index :scores, :created_at
  end

  def self.down
    remove_index :scores, :created_at
  end
end
