class AddMediumUrlToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :medium_url, :string
  end

  def self.down
    remove_column :videos, :medium_url
  end
end
