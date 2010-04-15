class AddTitleIndexToNewswires < ActiveRecord::Migration
  def self.up
    add_index :newswires, :title
  end

  def self.down
    remove_index :newswires, :title
  end
end
