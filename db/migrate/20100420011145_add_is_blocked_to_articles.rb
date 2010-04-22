class AddIsBlockedToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :is_blocked
  end
end
