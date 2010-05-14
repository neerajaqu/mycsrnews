class AddNewswiresToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :newswire_id, :integer, :null => true
  end

  def self.down
    remove_column :contents, :newswire_id
  end
end
