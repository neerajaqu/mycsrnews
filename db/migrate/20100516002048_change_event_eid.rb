class ChangeEventEid < ActiveRecord::Migration
  def self.up
    change_column :events, :eid, :string
    add_index :events, :eid
  end

  def self.down
    remove_index :events, :eid
    change_column :events, :eid, :integer
  end
end
