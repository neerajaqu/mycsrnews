class CreateViewObjectTemplates < ActiveRecord::Migration
  def self.up
    create_table :view_object_templates do |t|
      t.string :template
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :view_object_templates
  end
end
