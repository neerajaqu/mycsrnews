class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def after_save(user)
    ['newest_users'].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
  end

  def self.expire_user_all user
    puts "Sweeping newswires"
    controller = ActionController::Base.new
    controller.expire_fragment "newest_users"
    ['newest_users', 'recent_users', 'active_users', 'moderator_users', 'sidebar_top_users_weekly'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
  end

end
