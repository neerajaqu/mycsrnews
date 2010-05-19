class AddStoryTypeFields < ActiveRecord::Migration
  def self.up
    add_column :contents, :story_type, :string, :default => 'story'
    add_column :contents, :summary, :string
    add_column :contents, :full_html, :text

    add_index :contents, :story_type
  end

  def self.down
    remove_index :contents, :story_type

    remove_column :contents, :story_type
    remove_column :contents, :summary
    remove_column :contents, :full_html
  end
end
