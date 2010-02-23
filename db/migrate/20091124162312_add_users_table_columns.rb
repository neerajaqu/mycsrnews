class AddUsersTableColumns < ActiveRecord::Migration
  def self.up
    add_column :users, :login,                     :string, :limit => 40
    add_column :users, :crypted_password,          :string, :limit => 40
    add_column :users, :salt,                      :string, :limit => 40
    add_column :users, :updated_at,                :datetime
    add_column :users, :remember_token,            :string, :limit => 40
    add_column :users, :remember_token_expires_at, :datetime
    add_column :users, :fb_user_id, :integer
    add_column :users, :email_hash, :string

    add_index :users, :login, :unique => true

    execute("alter table users modify fb_user_id bigint")
  end

  def self.down
    remove_column :users, :login
    remove_column :users, :crypted_password
    remove_column :users, :salt
    remove_column :users, :updated_at
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
  end
end
