class AddThumbUrlToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :thumb_url, :string
    add_column :videos, :video_processing, :boolean
  end

  def self.down
    remove_column :videos, :thumb_url
    remove_column :videos, :video_processing
  end
end
