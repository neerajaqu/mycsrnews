class RemindersWorker
  @queue = :reminders

  def self.perform()
=begin
    needs to run nightly
    posts notification to any user we havent reminded recently to add email
    generate a pfeed item for...all users who:
    a) aren't enabled for email email <> '' and receive_email_notifications
    b) haven't turned off email reminders  dont_ask_me_for_email
    c) haven't been asked in two weeks email_last_ask
=end
    # reminder: sign up for email
    admin = Metadata::Setting.find_setting('site_notification_user').value
    user = User.find_by_fb_user_id(admin) || User.find_by_id(admin) || User.admins.last
    if user
      recipients = UserProfile.find(:all, :conditions => [ "dont_ask_me_for_email = ? and (email = ? or receive_email_notifications = ?) and (email_last_ask < date_sub(NOW(), INTERVAL 2 WEEK) or email_last_ask is null)",0, '', 0], :order => "user_id DESC", :joins => :user).map(&:user)
      recipients.each do |recipient|
        chirp = Chirp.new({
          :chirper => user,
          :recipient => recipient,
          :message => ActionView::Base.new.render(:partial => "#{RAILS_ROOT}/app/views/reminders/email_signup.html.haml", :locals => { :user => recipient } ) 
        })
        if chirp.valid? and recipient.sent_chirps.push chirp
          recipient.user_profile.update_attribute(:email_last_ask, Time.now)
        end
      end      
    end
  end
end
