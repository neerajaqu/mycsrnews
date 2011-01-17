class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string  :title
      t.text    :description
      t.integer :user_id
      t.boolean :is_public, :default => false

      # Default fields
      t.integer :votes_tally, :default => 0
      t.integer :comments_count, :default => 0
      t.boolean :is_featured, :default => false
      t.datetime  :featured_at, :default => nil
      t.integer :flags_count, :default => 0
      t.boolean :is_blocked, :default => false

      t.timestamps
    end

    add_index :galleries, :user_id
    add_index :galleries, :title
  end

  def self.down
    remove_index :galleries, :user_id
    remove_index :galleries, :title
    drop_table :galleries
  end
end
