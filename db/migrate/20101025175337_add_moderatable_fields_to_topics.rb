class AddModeratableFieldsToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :is_featured, :boolean, :default => false
    add_column :topics, :featured_at, :datetime, :default => nil
    add_column :topics, :flags_count, :integer, :default => 0
  end

  def self.down
    remove_column :topics, :is_featured
    remove_column :topics, :featured_at
    remove_column :topics, :flags_count
  end
end
