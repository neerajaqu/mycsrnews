class CreatePredictionGuesses < ActiveRecord::Migration
  def self.up
    create_table :prediction_guesses do |t|
      t.integer :prediction_question_id
      t.integer :user_id
      t.string :guess
      t.integer :guess_numeric
      t.datetime :guess_date
      t.boolean  :is_blocked,                  :default => false
      t.boolean  :is_featured,                 :default => false
      t.datetime :featured_at
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_guesses
  end
end
