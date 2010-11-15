class AddFbOauthDeniedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_oauth_denied_at, :datetime, :default => nil
  end

  def self.down
    remove_column :users, :fb_oauth_denied_at
  end
end
