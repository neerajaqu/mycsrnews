class AddEventSourcetoEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :alt_url, :string
    add_column :events, :source, :string
  end

  def self.down
    remove_column :events, :source
    remove_column :events, :alt_url
  end
end
