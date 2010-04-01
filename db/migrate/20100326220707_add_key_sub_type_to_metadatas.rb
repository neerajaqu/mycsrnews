class AddKeySubTypeToMetadatas < ActiveRecord::Migration
  def self.up
    add_column :metadatas, :key_sub_type, :string

    add_index :metadatas, [:key_type, :key_sub_type, :key_name]
  end

  def self.down
    remove_column :metadatas, :key_sub_type
    remove_index :metadatas, [:key_type, :key_sub_type, :key_name]
  end
end
