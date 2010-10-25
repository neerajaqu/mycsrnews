class AddModeratableFieldsToForums < ActiveRecord::Migration
  def self.up
    add_column :forums, :is_blocked, :boolean, :default => false
    add_column :forums, :is_featured, :boolean, :default => false
    add_column :forums, :featured_at, :datetime, :default => nil
  end

  def self.down
    remove_column :forums, :is_blocked
    remove_column :forums, :is_featured
    remove_column :forums, :featured_at
  end
end
