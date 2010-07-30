class AddInviteFriendsLastAskToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :dont_ask_me_invite_friends, :boolean, :default => false
    add_column :user_profiles, :invite_last_ask, :datetime
  end

  def self.down
    remove_column :user_profiles, :dont_ask_me_invite_friends
    remove_column :user_profiles, :invite_last_ask
  end

end
