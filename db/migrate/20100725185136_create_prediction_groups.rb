class CreatePredictionGroups < ActiveRecord::Migration
  def self.up
    create_table :prediction_groups do |t|
      t.string :title
      t.string :section
      t.text :description
      t.string :status
      t.integer :user_id
      t.boolean :is_approved, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_groups
  end
end
