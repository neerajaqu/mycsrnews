class ConvertIdeasTable < ActiveRecord::Migration
  def self.up
    # HACKETY HACK:: we need to use an intermediary table name because of case sensitivity issues
    # with mysql on different platorms......... sweet.
    rename_table  :Ideas,      :tmp_ideas
    rename_table  :tmp_ideas,  :ideas

    rename_column :ideas, :userid,        :user_id
    rename_column :ideas, :tagid,         :old_tag_id
    rename_column :ideas, :videoid,       :old_video_id
    rename_column :ideas, :numComments,   :comments_count
    rename_column :ideas, :numLikes,      :likes_count
    rename_column :ideas, :idea,          :title

    rename_column :ideas, :dt,            :created_at
    add_column    :ideas, :updated_at,    :datetime
  end

  def self.down
    rename_table :ideas, :tmp_ideas
    rename_table :tmp_ideas, :Ideas
  end
end
