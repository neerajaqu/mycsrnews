class ClassifiedsWorker
  @queue = :classifieds

  # needs to run nightly
  def self.perform()
    admin = Metadata::Setting.find_setting('site_notification_user').value
    user = User.active.find_by_fb_user_id(admin) || User.active.find_by_id(admin) || User.active.admins.last
    if user
      # send near expiration messages
=begin
    posts notification to any user whose classified listing is nearing expiration e.g. 3 days
=end
      classifieds = Classified.active.find(:all, :conditions => [ "(expires_at < date_add(NOW(), INTERVAL 3 DAY) and dont_ask_me_for_email = ? and receive_email_notifications = ? )",0, 1], :order => "user_id DESC", :joins => :user).map(&:user)
      classifieds.each do |classified|
        chirp = Chirp.new({
          :chirper => user,
          :recipient => classified.user,
          :message => ActionView::Base.new.render(:partial => "#{RAILS_ROOT}/app/views/classifieds/_near_expiration.html.haml", :locals => { :user => classified.user, :title =>  classified } ) 
        })
        #if chirp.valid? and user.sent_chirps.push chirp
          #recipient.user_profile.update_attribute(:email_last_ask, Time.now)
        #end
      end      

      # send expired message
=begin
    posts notification to any user whose classified listing has expired
=end
      classifieds = Classified.active.find(:all, :conditions => [ "(expires_at > date_sub(NOW(), INTERVAL 24 HOUR) and dont_ask_me_for_email = ? and receive_email_notifications = ? )",0, 1], :order => "user_id DESC", :joins => :user).map(&:user)
      classifieds.each do |classified|
        chirp = Chirp.new({
          :chirper => user,
          :recipient => classified.user,
          :message => ActionView::Base.new.render(:partial => "#{RAILS_ROOT}/app/views/classifieds/_expired.html.haml", :locals => { :user => classified.user, :title =>  classified } ) 
        })
      end      
    end
  end
end
