class CreatePredictionScores < ActiveRecord::Migration
  def self.up
    create_table :prediction_scores do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_scores
  end
end
