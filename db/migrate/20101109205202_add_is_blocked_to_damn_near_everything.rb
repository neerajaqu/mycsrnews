class AddIsBlockedToDamnNearEverything < ActiveRecord::Migration
  def self.up
		add_column :announcements, :is_blocked, :boolean, :default => false
		add_column :audios, :is_blocked, :boolean, :default => false
		add_column :cards, :is_blocked, :boolean, :default => false
		add_column :chirps, :is_blocked, :boolean, :default => false
		add_column :dashboard_messages, :is_blocked, :boolean, :default => false
		add_column :feeds, :is_blocked, :boolean, :default => false
		add_column :newswires, :is_blocked, :boolean, :default => false
		add_column :pfeed_deliveries, :is_blocked, :boolean, :default => false
		add_column :pfeed_items, :is_blocked, :boolean, :default => false
		add_column :prediction_scores, :is_blocked, :boolean, :default => false
		add_column :sent_cards, :is_blocked, :boolean, :default => false
		add_column :sources, :is_blocked, :boolean, :default => false
		add_column :taggings, :is_blocked, :boolean, :default => false
		add_column :tags, :is_blocked, :boolean, :default => false
		add_column :user_profiles, :is_blocked, :boolean, :default => false

  end

  def self.down
		remove_column :announcements, :is_blocked
		remove_column :audios, :is_blocked
		remove_column :cards, :is_blocked
		remove_column :chirps, :is_blocked
		remove_column :dashboard_messages, :is_blocked
		remove_column :feeds, :is_blocked
		remove_column :newswires, :is_blocked
		remove_column :pfeed_deliveries, :is_blocked
		remove_column :pfeed_items, :is_blocked
		remove_column :prediction_scores, :is_blocked
		remove_column :sent_cards, :is_blocked
		remove_column :sources, :is_blocked
		remove_column :taggings, :is_blocked
		remove_column :tags, :is_blocked
		remove_column :user_profiles, :is_blocked
  end
end
