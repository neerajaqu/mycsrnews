class AddPreambleToArticlesTable < ActiveRecord::Migration
  def self.up
    add_column :articles, :preamble, :text
  end

  def self.down
    remove_column :articles, :preamble
  end
end
