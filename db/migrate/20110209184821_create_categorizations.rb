class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations do |t|
      t.integer :category_id
      t.integer :categorizable_id
      t.string  :categorizable_type

      t.timestamps
    end

    add_index :categorizations, :category_id
    add_index :categorizations, [:categorizable_type, :categorizable_id]
  end

  def self.down
    remove_index :categorizations, :category_id
    remove_index :categorizations, [:categorizable_type, :categorizable_id]
    drop_table :categorizations
  end
end
