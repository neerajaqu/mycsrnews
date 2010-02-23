class ConvertUserTable < ActiveRecord::Migration
  def self.up
    rename_table  :User,  :users
    rename_column :users, :ncUid,           :ncu_id
    rename_column :users, :userid,          :id
    rename_column :users, :votePower,       :vote_power
    rename_column :users, :isAdmin,         :is_admin
    rename_column :users, :isBlocked,       :is_blocked
    rename_column :users, :isMember,        :is_member
    rename_column :users, :isModerator,     :is_moderator
    rename_column :users, :isSponsor,       :is_sponsor
    rename_column :users, :isResearcher,    :is_researcher
    rename_column :users, :isEmailVerified, :is_email_verified
    rename_column :users, :acceptRules,     :accept_rules
    rename_column :users, :optInStudy,      :opt_in_study
    rename_column :users, :optInEmail,      :opt_in_email
    rename_column :users, :optInProfile,    :opt_in_profile
    rename_column :users, :optInFeed,       :opt_in_feed
    rename_column :users, :optInSMS,        :opt_in_sms
    rename_column :users, :dateRegistered,  :created_at

    change_column :users, :remoteStatus, :string
    change_column :users, :eligibility, :string

    execute "ALTER TABLE users DROP PRIMARY KEY"
    execute "ALTER TABLE users CHANGE id id int(11) DEFAULT NULL auto_increment PRIMARY KEY"

  end

  def self.down
  end
end
