class AddTimestampsToComments < ActiveRecord::Migration
  def self.up
    rename_column :comments, :date, :created_at
    add_column :comments, :updated_at, :datetime
  end

  def self.down
    remove_column :comments, :created_at
    remove_column :comments, :updated_at
  end
end
