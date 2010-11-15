class AddFbOauthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_oauth_key, :string
  end

  def self.down
    remove_column :users, :fb_oauth_key
  end
end
