class CreateIdeaBoards < ActiveRecord::Migration
  def self.up
    create_table :idea_boards do |t|
      t.string :name
      t.string :section
      t.string :description

      t.timestamps
    end

    add_column :ideas, :idea_board_id, :integer
  end

  def self.down
    drop_table :idea_boards
    remove_column :ideas, :idea_board_id
  end
end
