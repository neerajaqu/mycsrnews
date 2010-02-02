class UpdateNewswireTable < ActiveRecord::Migration
  def self.up
    rename_table  :Newswire,  :newswires
    rename_column :newswires, :date, :created_at
    add_column :newswires, :updated_at, :datetime
    rename_column :newswires, :feedid, :feed_id
    change_column :newswires, :feedType, :string
  end

  def self.down
  end
end
