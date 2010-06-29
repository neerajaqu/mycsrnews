class AddIndexToSources < ActiveRecord::Migration
  def self.up
  end

  add_index :sources, :url, :unique => true

  def self.down
  end
end
