class AddCountsForPredictions < ActiveRecord::Migration
  def self.up
    add_column :prediction_groups, :prediction_questions_count, :integer, :default => 0
    add_column :prediction_questions, :prediction_guesses_count, :integer, :default => 0
    remove_column :prediction_groups, :questions_count
    remove_column :prediction_questions, :guesses_count
  end

  def self.down
    remove_column :prediction_groups, :prediction_questions_count
    remove_column :prediction_questions, :prediction_guesses_count
  end
end
