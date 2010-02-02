class CreateFeaturedItems < ActiveRecord::Migration
  def self.up
    create_table :featured_items do |t|
      t.integer :parent_id
      t.integer :featurable_id
      t.string  :featurable_type
      t.string  :featured_type
      t.string  :name

      t.timestamps
    end

    add_index :featured_items, [:featurable_type, :featurable_id]
    add_index :featured_items, :name
    add_index :featured_items, :featured_type
    add_index :featured_items, :parent_id

  end

  def self.down
    drop_table :featured_items
  end
end
