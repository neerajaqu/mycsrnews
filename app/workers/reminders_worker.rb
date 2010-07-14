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
    #User.find(:all, :conditions => [ "email != ?", ''])
    #UserProfile.find(:all, :conditions => [ "dont_ask_me_for_email = ? and receive_email_notifications = ? and email_last_ask < date_sub(NOW(), INTERVAL 2 WEEK)", 0, 1], :order => "user_id DESC")
    # construct and send pfeed notification item

    # update UserProfile
    # UserProfile email_last_ask = now()
  end

end
