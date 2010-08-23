class AddIndexForRemoteImageUrlToImages < ActiveRecord::Migration
  def self.up
    add_index :images, :remote_image_url
  end

  def self.down
    remove_index :images, :remote_image_url
  end
end
