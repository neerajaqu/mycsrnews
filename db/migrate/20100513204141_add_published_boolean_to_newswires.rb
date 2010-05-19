class AddPublishedBooleanToNewswires < ActiveRecord::Migration
  def self.up
    add_column :newswires, :published, :boolean, :default => false
  end

  def self.down
    remove_column :newswires, :published
  end
end
