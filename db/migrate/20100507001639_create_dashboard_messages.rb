class CreateDashboardMessages < ActiveRecord::Migration
  def self.up
    create_table :dashboard_messages do |t|
      t.string  :message
      t.string  :action_text
      t.string  :action_url
      t.string  :image_url
      t.string  :status, :default => 'draft'
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :dashboard_messages
  end
end
