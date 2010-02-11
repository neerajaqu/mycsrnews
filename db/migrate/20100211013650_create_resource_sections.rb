class CreateResourceSections < ActiveRecord::Migration
  def self.up
    create_table :resource_sections do |t|
      t.string :name
      t.string :section
      t.string :description
      t.timestamps
    end
    add_column :resources, :resource_section_id, :integer
  end

  def self.down
    drop_table :resource_sections
    remove_column :resources, :resource_section_id
  end
end
