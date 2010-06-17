class CreateTweetedItems < ActiveRecord::Migration
  def self.up
    create_table :tweeted_items do |t|
      t.string :item_type
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tweeted_items
  end
end
