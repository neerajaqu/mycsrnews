class CreateViewObjectTemplates < ActiveRecord::Migration
  def self.up
    create_table :view_object_templates do |t|
      t.string :template
      t.string :name
      t.string :pretty_name

      t.timestamps
    end

    add_index :view_object_templates, :name
  end

  def self.down
    remove_index :view_object_templates, :name
    drop_table :view_object_templates
  end
end
