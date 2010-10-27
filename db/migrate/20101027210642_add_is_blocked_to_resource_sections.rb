class AddIsBlockedToResourceSections < ActiveRecord::Migration
  def self.up
    add_column :resource_sections, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :resource_sections, :is_blocked
  end
end
