class CreateMetadatas < ActiveRecord::Migration
  def self.up
    create_table :metadatas do |t|
      t.string  :metadatable_type
      t.integer :metadatable_id
      t.string  :key_name
      t.string  :key_type
      t.string  :meta_type
      t.text    :data

      t.timestamps
    end

    add_index :metadatas, [:metadatable_type, :metadatable_id]
    add_index :metadatas, [:key_type, :key_name]
    add_index :metadatas, :key_name
  end

  def self.down
    drop_table :metadatas
  end
end
