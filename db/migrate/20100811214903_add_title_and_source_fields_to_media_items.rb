class AddTitleAndSourceFieldsToMediaItems < ActiveRecord::Migration
  def self.up
    add_column :images, :title, :string
    add_column :images, :source_id, :integer
    add_column :videos, :title, :string
    add_column :videos, :source_id, :integer
    add_column :audios, :source_id, :integer
  end

  def self.down
    remove_column :images, :title
    remove_column :images, :source_id
    remove_column :videos, :title
    remove_column :videos, :source_id
    remove_column :audios, :source_id
  end
end
