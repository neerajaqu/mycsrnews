class ConvertCommentsTable < ActiveRecord::Migration
  def self.up
    # HACKETY HACK:: we need to use an intermediary table name because of case sensitivity issues
    # with mysql on different platorms......... sweet.
    rename_table  :Comments,      :tmp_comments
    rename_table  :tmp_comments,  :comments
    rename_column :comments, :siteContentId,  :content_id
    rename_column :comments, :userid,         :user_id
    rename_column :comments, :siteCommentId,  :id

    execute "ALTER TABLE comments DROP PRIMARY KEY"
    execute "ALTER TABLE comments CHANGE id id int(11) DEFAULT NULL auto_increment PRIMARY KEY"

    #TODO:: initial comments_count for content
  end

  def self.down
  end
end
