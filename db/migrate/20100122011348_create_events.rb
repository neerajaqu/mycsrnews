class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :eid
      t.string  :name
      t.string  :tagline
      t.string  :pic
      t.string  :pic_big
      t.string  :pic_small
      t.string  :host
      t.string  :location
      t.string  :street
      t.string  :city
      t.string  :state
      t.string  :country
      t.text  :description
      t.string  :event_type
      t.string  :event_subtype
      t.string  :privacy_type
      t.timestamp :start_time
      t.timestamp :end_time
      t.timestamp :update_time
      t.boolean :isApproved
      t.integer :nid
      t.integer :creator
      t.integer :user_id
      t.integer :likes_count
      t.integer :comments_count
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
