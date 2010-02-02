class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :title, :null => false
      t.text :details
      t.string :url
      t.string :mapUrl
      t.string :twitterName
      t.integer :likes_count
      t.integer :comments_count    
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
