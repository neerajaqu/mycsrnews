class CreateClassifieds < ActiveRecord::Migration
  def self.up
    create_table :classifieds do |t|
      t.string :title
      t.text :details
      t.string :aasm_state
      t.string :listing_type
      t.string :allow
      t.integer :user_id
      t.datetime :expires_at, :default => nil
      t.price :float

      # Default fields
      t.integer :votes_tally, :default => 0
      t.integer :comments_count, :default => 0
      t.boolean :is_featured, :default => false
      t.datetime  :featured_at, :default => nil
      t.integer :flags_count, :default => 0
      t.boolean :is_blocked, :default => false

      t.timestamps
    end

    add_index :classifieds, :user_id
    add_index :classifieds, :aasm_state
    add_index :classifieds, :expires_at
  end

  def self.down
    remove_index :classifieds, :user_id
    remove_index :classifieds, :aasm_state
    remove_index :classifieds, :expires_at
    drop_table :classifieds
  end
end
