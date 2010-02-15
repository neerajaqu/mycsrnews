class SwitchContentImageTimestamps < ActiveRecord::Migration
  def self.up
    rename_column :content_images, :date, :created_at
    add_column :content_images, :updated_at, :datetime
  end

  def self.down
    rename_column :content_images, :created_at, :date
    remove_column :content_images, :updated_at
  end
end
