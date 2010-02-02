class ConvertUserInfoTable < ActiveRecord::Migration
  def self.up
    rename_table  :UserInfo,  :user_infos
    rename_column :user_infos, :fbId,            :facebook_user_id
    rename_column :user_infos, :userid,          :user_id

    change_column :user_infos, :gender, :string

    add_column :user_infos, :id, :integer

    execute "ALTER TABLE user_infos DROP PRIMARY KEY"
    execute "ALTER TABLE user_infos CHANGE id id int(11) DEFAULT NULL auto_increment PRIMARY KEY"

    add_index :user_infos, :user_id, :unique => true
  end

  def self.down
  end
end
