class ModifyRelatedItemsForRelatable < ActiveRecord::Migration
  def self.up
    add_column :related_items, :relatable_type, :string
    add_column :related_items, :relatable_id, :integer
    remove_column :related_items, :item_id
  end

  def self.down
    remove_column :related_items, :relatable_type
    remove_column :related_items, :relatable_id
    add_column :related_items, :item_id, :integer
  end
end
