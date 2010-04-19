class CreateSentCards < ActiveRecord::Migration
  def self.up
    create_table :sent_cards do |t|
      t.integer :from_user_id
      t.integer :to_fb_user_id, :limit => 8
      t.integer :card_id

      t.timestamps
    end

    add_index :sent_cards, :card_id
    add_index :sent_cards, :from_user_id
    add_index :sent_cards, :to_fb_user_id
    add_index :sent_cards, [:from_user_id, :card_id]
    add_index :sent_cards, [:from_user_id, :card_id, :to_fb_user_id]
  end

  def self.down
    drop_table :sent_cards
  end
end
