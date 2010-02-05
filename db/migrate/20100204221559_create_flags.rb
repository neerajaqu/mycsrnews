class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.string :flag_type
      t.integer :user_id
      t.string :flagable_type
      t.integer :flagable_id
      t.timestamps
    end
    add_index :flags, [:flagable_type, :flagable_id]
  end

  def self.down
    drop_table :flags
  end
end
