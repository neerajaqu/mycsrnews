class ChangeBlockedComments < ActiveRecord::Migration
  def self.up
      rename_column :comments, :isBlocked,       :is_blocked
    end

    def self.down
      rename_column :comments, :is_blocked,       :isBlocked
  end
end
