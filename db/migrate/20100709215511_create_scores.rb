class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :user_id
      t.string  :scorable_type
      t.integer :scorable_id
      t.string  :score_type
      t.integer :value

      t.timestamps
    end

    add_index :scores, [:scorable_type, :scorable_id]
    add_index :scores, :scorable_type
    add_index :scores, :user_id
    add_index :scores, :score_type
  end

  def self.down
    remove_index :scores, [:scorable_type, :scorable_id]
    remove_index :scores, :scorable_type
    remove_index :scores, :user_id
    remove_index :scores, :score_type

    drop_table :scores
  end
end
