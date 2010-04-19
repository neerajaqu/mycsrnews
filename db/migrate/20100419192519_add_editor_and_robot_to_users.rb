class AddEditorAndRobotToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_editor,  :boolean, :default => false
    add_column :users, :is_robot,  :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_editor
    remove_column :users, :is_robot
  end
end
