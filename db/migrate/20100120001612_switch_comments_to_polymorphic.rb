class SwitchCommentsToPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :comments, :content_id, :commentable_id
    add_column    :comments, :commentable_type, :string

    add_index :comments, [:commentable_type, :commentable_id]
  end

  def self.down
    remove_index  :comments [:commentable_type, :commentable_id]
    rename_column :comments, :commentable_id, :content_id
    remove_column :comments, :commentable_type
  end
end
