class AddFlagCounts < ActiveRecord::Migration
  def self.up
    add_column  :ideas, :flags_count, :integer, :default => 0
    add_column  :comments, :flags_count, :integer, :default => 0
    add_column  :contents, :flags_count, :integer, :default => 0
    add_column  :resources, :flags_count, :integer, :default => 0
  end

  def self.down
    remove_column :ideas, :flags_count
    remove_column :comments, :flags_count
    remove_column :contents, :flags_count
    remove_column :resources, :flags_count
  end
end
