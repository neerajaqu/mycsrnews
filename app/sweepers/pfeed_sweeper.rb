class PfeedSweeper < ActionController::Caching::Sweeper

  def self.expire_pfeed_all pfeed
    controller = ActionController::Base.new
    ['latest_pfeeds'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    NewscloudSweeper.expire_instance(pfeed)
  end

end
