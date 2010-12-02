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
  end

end
