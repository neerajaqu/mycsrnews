class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string  :categorizable_type
      t.integer :parent_id, :default => nil
      t.string  :name
      t.string  :context

      t.timestamps
    end

    add_index :categories, :parent_id
    add_index :categories, :categorizable_type
    add_index :categories, :context
  end

  def self.down
    remove_index :categories, :parent_id
    remove_index :categories, :categorizable_type
    remove_index :categories, :context
    drop_table :categories
  end
end
