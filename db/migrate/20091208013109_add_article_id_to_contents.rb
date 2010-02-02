class AddArticleIdToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :article_id, :integer, :null => true
  end

  def self.down
    remove_column :contents, :article_id
  end
end
