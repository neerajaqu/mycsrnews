class CreateGos < ActiveRecord::Migration
  def self.up
    create_table :gos do |t|
      t.string  :goable_type
      t.integer :goable_id
      t.integer :user_id
      t.string  :name
      t.string  :cached_slug
      t.integer :views_count, :default => 0
      t.boolean :is_featured, :default => false
      t.datetime  :featured_at, :default => nil
      t.integer :flags_count, :default => 0
      t.boolean :is_blocked, :default => false

      t.timestamps
    end
    add_index :gos, :user_id
    add_index :gos, :cached_slug
    add_index :gos, :name
    add_index :gos, [:goable_type, :goable_id]
  end

  def self.down
    remove_index :gos, :user_id
    remove_index :gos, :cached_slug
    remove_index :gos, :name
    remove_index :gos, [:goable_type, :goable_id]
    drop_table :gos
  end
end
