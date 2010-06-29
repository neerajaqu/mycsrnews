class AddSourceIdToContentTable < ActiveRecord::Migration
  def self.up
    add_column :contents, :source_id, :integer
  end

  def self.down
    remove_column :contents, :source_id
  end
end
