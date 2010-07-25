class CreatePredictionQuestions < ActiveRecord::Migration
  def self.up
    create_table :prediction_questions do |t|
      t.integer :prediction_group_id
      t.string :title
      t.string :type
      t.string :status
      t.integer :user_id
      t.boolean :is_approved, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :prediction_questions
  end
end
