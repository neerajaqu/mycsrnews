class AddPositionToWidgetPages < ActiveRecord::Migration
  def self.up
    add_column :widget_pages, :position, :string
  end

  def self.down
    remove_column :widget_pages, :position
  end
end
