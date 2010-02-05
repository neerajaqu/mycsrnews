class ChangeBlockedContent < ActiveRecord::Migration
  def self.up
    rename_column :contents, :isBlocked,       :is_blocked
  end

  def self.down
    rename_column :contents, :is_blocked,       :isBlocked
  end
end
