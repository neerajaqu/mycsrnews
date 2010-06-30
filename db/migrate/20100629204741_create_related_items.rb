class CreateRelatedItems < ActiveRecord::Migration
  def self.up
    create_table :related_items do |t|
      t.string :title
      t.string :url
      t.text    :notes
      t.integer :item_id
      t.integer :user_id
      t.boolean :is_blocked, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :related_items
  end
end
