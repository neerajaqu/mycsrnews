class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :prefix
      t.string :title, :null => false
      t.text :details
      t.string :url
      t.string :type, :default => 'rotate'
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end