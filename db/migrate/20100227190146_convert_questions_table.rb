class ConvertQuestionsTable < ActiveRecord::Migration
  def self.up
    rename_table  :AskQuestions, :questions
		rename_column :questions, :userid, :user_id
		rename_column :questions, :numLikes, :votes_tally
		rename_column :questions, :numComments, :comments_count
		rename_column :questions, :numAnswers, :answers_count
		rename_column :questions, :dt, :created_at
		add_column    :questions, :updated_at, :datetime
		add_column    :questions, :is_blocked, :boolean, :default => false
		add_column    :questions, :is_featured, :boolean, :default => false
		add_column    :questions, :featured_at, :datetime
    remove_column :questions, :videoid
    remove_column :questions, :tagid

    add_index :questions, :user_id
  end

  def self.down
  end
end
