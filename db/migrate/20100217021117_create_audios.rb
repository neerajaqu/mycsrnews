class CreateAudios < ActiveRecord::Migration
  def self.up
    create_table :audios do |t|
      t.string  :audioable_type
      t.integer :audioable_id
      t.integer :user_id
      t.string  :url
      t.string  :title
      t.string  :artist
      t.string  :album
      t.text    :caption

      t.timestamps
    end

    add_index :audios, [:audioable_type, :audioable_id]
    add_index :audios, :user_id
  end

  def self.down
    drop_table :audios
  end
end
