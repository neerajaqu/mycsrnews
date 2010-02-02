class CreateWidgets < ActiveRecord::Migration
  def self.up
    drop_table :Widgets
    create_table :widgets do |t|
      t.string  :name
      t.string  :load_functions
      t.string  :locals
      t.string  :partial
      t.string  :content_type
      t.text    :metadata

      t.timestamps
    end

    add_index :widgets, :name
  end

  def self.down
    drop_table :widgets
  end
end
