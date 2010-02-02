class CreateWidgetPages < ActiveRecord::Migration
  def self.up
    create_table :widget_pages do |t|
      t.integer :widget_id
      t.integer :parent_id
      t.string  :widget_type
      t.string  :name

      t.timestamps
    end

    add_index :widget_pages, :widget_id
    add_index :widget_pages, :parent_id
    add_index :widget_pages, :widget_type
    add_index :widget_pages, :name
  end

  def self.down
    drop_table :widget_pages
  end
end
