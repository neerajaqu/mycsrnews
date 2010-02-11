class AddBlockedToResources < ActiveRecord::Migration
  def self.up
      add_column  :resources, :is_blocked, :boolean, :default => false
    end

    def self.down
      remove_column :resources, :is_blocked
  end
end
