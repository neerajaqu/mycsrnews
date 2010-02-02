class AddCachedSlugToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :cached_slug, :string
  end

  def self.down
    remove_column :contents, :cached_slug
  end
end
