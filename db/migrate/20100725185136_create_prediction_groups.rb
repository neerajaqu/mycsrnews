class CreatePredictionGroups < ActiveRecord::Migration
  def self.up
    create_table :prediction_groups do |t|
      t.string :title
      t.string :section
      t.text :description
      t.string :status, :default => 'open'
      t.integer :user_id
      t.boolean :is_approved, :default => true
      t.integer  :votes_tally,                 :default => 0
      t.integer  :comments_count,              :default => 0
      t.integer  :questions_count,              :default => 0
      t.boolean  :is_blocked,                  :default => false
      t.boolean  :is_featured,                 :default => false
      t.datetime :featured_at
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_groups
  end
end
