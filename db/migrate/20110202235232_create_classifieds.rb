class CreateClassifieds < ActiveRecord::Migration
  def self.up
    create_table :classifieds do |t|
      t.string :title
      t.text :details
      t.string :aasm_state
      t.integer :user_id
      t.datetime :expires_at, :default => nil
      t.price :float

      t.timestamps
    end

    add_index :classifieds, :user_id
  end

  def self.down
    remove_index :classifieds, :user_id
    drop_table :classifieds
  end
end
