class AddReadCountToNewswires < ActiveRecord::Migration
  def self.up
    add_column :newswires, :read_count, :integer
  end

  def self.down
    remove_column :newswires, :read_count
  end
end
