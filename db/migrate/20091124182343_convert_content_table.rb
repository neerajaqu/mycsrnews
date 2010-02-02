class ConvertContentTable < ActiveRecord::Migration
  def self.up
    rename_table  :Content,  :contents
    rename_column :contents, :siteContentId,   :id
    rename_column :contents, :userid,          :user_id

    add_column  :contents, :comments_count, :integer, :default => 0

    execute "ALTER TABLE contents DROP PRIMARY KEY"
    execute "ALTER TABLE contents CHANGE id id int(11) DEFAULT NULL auto_increment PRIMARY KEY"
  end

  def self.down
  end
end
