class DeleteBlankUsers < ActiveRecord::Migration
  def self.up
    User.find(:all, :conditions => ["name = ''"]).each do |user|
      user.user_info.destroy if user.user_info.present?
      user.destroy
    end
  end

  def self.down
  end
end
