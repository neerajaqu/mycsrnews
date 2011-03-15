class CreateViewObjects < ActiveRecord::Migration
  def self.up
    create_table :view_objects do |t|
      t.string :name
      t.integer :parent_id
      t.integer :view_object_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :view_objects
  end
end
