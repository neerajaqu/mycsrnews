class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string  :videoable_type
      t.integer :videoable_id
      t.integer :user_id
      t.string  :remote_video_url
      t.boolean :is_blocked, :default => 0
      t.text    :description
      t.text    :embed_code
      t.string  :embed_src
      t.string  :remote_video_type
      t.string  :remote_video_id

      t.timestamps
    end
    add_index :videos, [:videoable_type, :videoable_id]
    add_index :videos, :user_id
  end

  def self.down
    drop_table :videos
  end
end
