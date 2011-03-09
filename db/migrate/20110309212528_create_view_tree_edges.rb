class CreateViewTreeEdges < ActiveRecord::Migration
  def self.up
    create_table :view_tree_edges do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end

    add_index :view_tree_edges, :parent_id
    add_index :view_tree_edges, :child_id
  end

  def self.down
    remove_index :view_tree_edges, :parent_id
    remove_index :view_tree_edges, :child_id
    drop_table :view_tree_edges
  end
end
