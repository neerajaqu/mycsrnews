class NotificationWorker
  @queue = :notifications

  # Takes a PfeedItem and stringified PfeedItem.attemp_delivery method params
  def self.perform(pfeed_item_id, ar_obj_klass_name, ar_obj_id, method_name_arr)
    pfeed_item = PfeedItem.find(pfeed_item_id)
    klass = ar_obj_klass_name.constantize
    ar_obj = klass.find(ar_obj_id)
    pfeed_item.deliver(ar_obj, method_name_arr)

    #todo - more notification types need to be handled
    admin = Metadata::Setting.find_setting('site_notification_user').value
    sender = User.find_by_fb_user_id(admin) || User.find_by_id(admin) || User.admins.last
    if sender
      from_email = (sender.email.present? ? sender.email : ActionMailer::Base.smtp_settings['user_name'] )
      pfeed_item.pfeed_deliveries.map(&:pfeed_receiver).each do |recipient|
        if recipient.accepts_email_notifications?
          message = {
          	  :sender => sender,
          	  :email => from_email,
          	  :recipient => recipient,
          	  :recipients => recipient.email,          	  
          	  :originator => pfeed_item.originator,
          	  :participant => pfeed_item.participant,
          	  :site_title => Metadata::Setting.find_setting('site_title').value
          	}
          	Notifier.send("deliver_#{pfeed_item.participant_type.underscore}_message",message)
        end
      end
    end
  end 
end