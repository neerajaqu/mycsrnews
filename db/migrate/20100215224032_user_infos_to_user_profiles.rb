class UserInfosToUserProfiles < ActiveRecord::Migration
  def self.up
    # remove these columns
    remove_column :user_infos, :cachedFriendsInvited
    remove_column :user_infos, :cachedChallengesCompleted
    remove_column :user_infos, :hideTipStories
    remove_column :user_infos, :hideTeamIntro
    remove_column :user_infos, :lastUpdateLevels
    remove_column :user_infos, :lastUpdateSiteChallenges
    remove_column :user_infos, :lastUpdateCachedPointsAndChallenges
    remove_column :user_infos, :lastUpdateCachedCommentsAndStories
    remove_column :user_infos, :lastNetSync
    remove_column :user_infos, :address1
    remove_column :user_infos, :address2
    remove_column :user_infos, :phone
    remove_column :user_infos, :lastRemoteSyncUpdate
    remove_column :user_infos, :lastProfileUpdate
    remove_column :user_infos, :lastInvite
    remove_column :user_infos, :friends
    remove_column :user_infos, :numFriends
    remove_column :user_infos, :numMemberFriends
    remove_column :user_infos, :memberFriends
    remove_column :user_infos, :researchImportance
    remove_column :user_infos, :rxConsentForm
    remove_column :user_infos, :networkid
    remove_column :user_infos, :gender
    remove_column :user_infos, :age
    remove_column :user_infos, :interests
    remove_column :user_infos, :city
    remove_column :user_infos, :state
    remove_column :user_infos, :country
    remove_column :user_infos, :zip
    remove_column :user_infos, :groups
    remove_column :user_infos, :networks
    remove_column :user_infos, :neighborhood
    
    # rename these columns
    rename_column :user_infos, :noCommentNotify, :comment_notifications
    rename_column :user_infos, :dateCreated, :created_at
    rename_column :user_infos, :lastUpdated, :updated_at
    rename_column :user_infos, :refuid, :referred_by_user_id
    rename_column :user_infos, :birthdate, :born_at
    # rename the table
    rename_table :user_infos, :user_profiles
  end

  def self.down
    # There is no going back 
  end
end
