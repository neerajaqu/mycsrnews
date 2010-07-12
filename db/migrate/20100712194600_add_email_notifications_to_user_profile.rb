class AddEmailNotificationsToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :receive_email_notifications, :boolean, :default => true
    add_column :user_profiles, :dont_ask_me_for_email, :boolean, :default => false
    add_column :user_profiles, :email_last_ask, :datetime
  end

  def self.down
    remove_column :user_profiles, :receive_email_notifications
    remove_column :user_profiles, :dont_ask_me_for_email
    remove_column :user_profiles, :email_last_ask
  end
end
