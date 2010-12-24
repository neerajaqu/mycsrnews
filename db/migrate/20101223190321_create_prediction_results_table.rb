class CreatePredictionResultsTable < ActiveRecord::Migration
  def self.up
    create_table :prediction_results do |t|
      t.integer :prediction_question_id
      t.string :result
      t.text :details
      t.string :url
      t.integer :user_id
      t.boolean :is_accepted, :default => false
      t.datetime :accepted_at
      t.integer :accepted_by_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_results
  end
end
