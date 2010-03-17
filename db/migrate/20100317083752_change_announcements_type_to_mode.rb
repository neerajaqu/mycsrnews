class ChangeAnnouncementsTypeToMode < ActiveRecord::Migration
  def self.up
    rename_column :announcements, :type, :mode
  end

  def self.down
    rename_column :announcements, :mode, :type
  end
end
