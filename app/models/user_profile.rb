class UserProfile < ActiveRecord::Base
  acts_as_moderatable

  belongs_to :user

  def expire
    self.class.sweeper.expire_user_all self.user
  end

  def self.expire_all
    self.sweeper.expire_user_all User.new
  end

  def self.sweeper
    UserSweeper
  end

end
