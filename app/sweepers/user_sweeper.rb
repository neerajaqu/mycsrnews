class UserSweeper < ActionController::Caching::Sweeper
  observe User

  def after_save(user)
    ['newest_users'].each do |fragment|
      expire_fragment "#{fragment}_html"
      expire_fragment "#{fragment}_fbml"
    end
  end

end
