class AddVoteTallyToModels < ActiveRecord::Migration
  def self.up
    rename_column :events, :likes_count, :votes_tally
    rename_column :ideas, :likes_count, :votes_tally
    rename_column :resources, :likes_count, :votes_tally
    rename_column :comments, :likes_count, :votes_tally
    add_column :contents, :votes_tally, :integer, :default => 0
    add_column :images, :votes_tally, :integer, :default => 0
    add_column :videos, :votes_tally, :integer, :default => 0
  end

  def self.down
    remove_column :images, :votes_tally
    remove_column :videos, :votes_tally
    remove_column :contents, :votes_tally
    rename_column :events, :votes_tally,:likes_count 
    rename_column :ideas, :votes_tally,:likes_count
    rename_column :resources, :votes_tally,:likes_count
    rename_column :comments, :votes_tally,:likes_count
  end
end
