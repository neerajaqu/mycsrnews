class ConvertContentImagesTable < ActiveRecord::Migration
  def self.up
    rename_table  :ContentImages,  :content_images
    rename_column :content_images, :siteContentId,   :content_id

    add_index :content_images, :content_id
  end

  def self.down
  end
end
