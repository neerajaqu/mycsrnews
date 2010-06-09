class AddTypeToMetadata < ActiveRecord::Migration
  def self.up
    add_column :metadatas, :type, :string
  end

  def self.down
    remove_column :metadatas, :type
  end
end
