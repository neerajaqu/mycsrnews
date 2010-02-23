class DeleteBlankUsers < ActiveRecord::Migration
  def self.up
    User.find(:all, :conditions => ["name = ''"]).each do |user|
      user.profile.destroy if user.profile.present?
      user.destroy
    end
  end

  def self.down
  end
end
