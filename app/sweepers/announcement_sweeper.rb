class AnnouncementSweeper < ActionController::Caching::Sweeper
  observe Announcement

  def after_save(announcement)
    ['newest_announcements'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
  end

  def after_destroy(record)
  	self.expire_announcement_all(announcement)
  end


end
