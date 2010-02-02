class AddKarmaScoreToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :karma_score, :integer, :default => 0
  end

  def self.down
    remove_column :users, :karma_score
  end
end
