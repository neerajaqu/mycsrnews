class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer   :forum_id
      t.integer   :user_id
      t.string    :title
      t.integer   :views_count, :default => 0
      t.integer   :comments_count, :default => 0
      t.datetime  :replied_at
      t.integer   :replied_user_id
      t.integer   :sticky, :default => 0
      t.integer   :last_comment_id
      t.boolean   :locked, :default => false

      t.timestamps
    end

    add_index :topics, :forum_id
    add_index :topics, :user_id
    add_index :topics, [:forum_id, :replied_at]
  end

  def self.down
    drop_table :topics
  end
end
