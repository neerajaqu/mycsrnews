class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string  :imageable_type
      t.integer :imageable_id
      t.integer :user_id
      t.text    :description
      t.string  :remote_image_url
      t.boolean :is_blocked, :default => 0

      # Paperclip Fields
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end
    add_index :images, [:imageable_type, :imageable_id]
    add_index :images, :user_id
  end

  def self.down
    drop_table :images
  end
end
