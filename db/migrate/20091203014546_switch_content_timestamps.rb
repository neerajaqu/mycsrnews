class SwitchContentTimestamps < ActiveRecord::Migration
  def self.up
    rename_column :contents, :date, :created_at
    add_column :contents, :updated_at, :datetime
  end

  def self.down
    rename_column :contents, :created_at, :date
    remove_column :contents, :updated_at
  end
end
