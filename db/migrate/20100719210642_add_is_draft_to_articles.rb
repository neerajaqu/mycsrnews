class AddIsDraftToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :is_draft, :boolean, :default => false
  end

  def self.down
  end
end
