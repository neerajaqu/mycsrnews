class CreateGalleryItems < ActiveRecord::Migration
  def self.up
    create_table :gallery_items do |t|
      t.string  :galleryable_type
      t.integer :galleryable_id
      t.integer :user_id
      t.integer :gallery_id
      t.string  :title
      t.string  :cached_slug
      t.text    :caption
      t.string  :item_url
      t.integer :position, :default => 0

      # Default fields
      t.integer :votes_tally, :default => 0
      t.integer :comments_count, :default => 0
      t.boolean :is_featured, :default => false
      t.datetime  :featured_at, :default => nil
      t.integer :flags_count, :default => 0
      t.boolean :is_blocked, :default => false

      t.timestamps
    end

    add_index :gallery_items, :user_id
    add_index :gallery_items, :cached_slug
    add_index :gallery_items, :title
    add_index :gallery_items, :gallery_id
    add_index :gallery_items, [:galleryable_type, :galleryable_id]
  end

  def self.down
    remove_index :gallery_items, :user_id
    remove_index :gallery_items, :cached_slug
    remove_index :gallery_items, :title
    remove_index :gallery_items, :gallery_id
    remove_index :gallery_items, [:galleryable_type, :galleryable_id]
    drop_table :gallery_items
  end
end
