class ContentsChangeFeatured < ActiveRecord::Migration
  def self.up
    rename_column :contents, :isFeatured, :is_featured
  end

  def self.down
    rename_column :contents,  :is_featured, :isFeatured
  end
end
