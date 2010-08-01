class AddPreambleCompleteToArticlesTable < ActiveRecord::Migration
  def self.up
    add_column :articles, :preamble_complete, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :preamble_complete
  end
end
