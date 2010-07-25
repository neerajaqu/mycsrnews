class CreatePredictionScores < ActiveRecord::Migration
  def self.up
    create_table :prediction_scores do |t|
      t.integer :user_id
      t.integer :guess_count
      t.integer :correct_count
      t.float :accuracy
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_scores
  end
end
