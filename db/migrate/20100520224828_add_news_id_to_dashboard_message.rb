class AddNewsIdToDashboardMessage < ActiveRecord::Migration
  def self.up
    add_column :dashboard_messages, :news_id, :integer, :null => true
  end

  def self.down
    remove_column :dashboard_messages, :news_id
  end
end
