class UpdateUserTimestamps < ActiveRecord::Migration
  def self.up
    User.find(:all, :conditions => ["created_at IS NULL and dateRegistered IS NOT NULL"]).each do |user|
      user.created_at = user.dateRegistered
      user.save
    end
  end

  def self.down
  end
end
