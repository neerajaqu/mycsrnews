class ConvertAnswersTable < ActiveRecord::Migration
  def self.up
    rename_table  :AskAnswers, :answers
		rename_column :answers, :questionid, :question_id
		rename_column :answers, :userid, :user_id
		rename_column :answers, :numLikes, :votes_tally
		rename_column :answers, :numComments, :comments_count
		rename_column :answers, :dt, :created_at
		add_column    :answers, :updated_at, :datetime
		add_column    :answers, :is_blocked, :boolean, :default => false
		add_column    :answers, :is_featured, :boolean, :default => false
		add_column    :answers, :featured_at, :datetime
    remove_column :answers, :videoid

    add_index :answers, :user_id
    add_index :answers, :question_id
  end

  def self.down
  end
end
