class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.string :flag_type
      t.integer :user_id
      t.string :flaggable_type
      t.integer :flaggable_id
      t.timestamps
    end
    add_index :flags, [:flaggable_type, :flaggable_id]
  end

  def self.down
    drop_table :flags
  end
end
