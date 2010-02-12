class AddModerationToEvents < ActiveRecord::Migration
  def self.up
      add_column :events, :is_featured, :boolean, :default => false
      add_column :events, :featured_at, :datetime
      add_column  :events, :is_blocked, :boolean, :default => false
      add_column  :events, :flags_count, :integer, :default => 0
    end

    def self.down
      remove_column :events, :is_blocked
      remove_column :events, :is_featured
      remove_column :events, :featured_at
      remove_column :events, :flags_count
  end
end
