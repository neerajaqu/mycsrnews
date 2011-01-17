class AddIsCorrectToPredictionGuess < ActiveRecord::Migration
  def self.up
    add_column :prediction_guesses, :is_correct, :boolean, :default => false
  end

  def self.down
    remove_column :prediction_guesses, :is_correct
  end
end
