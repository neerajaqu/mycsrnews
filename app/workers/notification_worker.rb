class NotificationWorker
  @queue = :notifications

  # Takes a PfeedItem and stringified PfeedItem.attemp_delivery method params
  def self.perform(pfeed_item_id, ar_obj_klass_name, ar_obj_id, method_name_arr)
    pfeed_item = PfeedItem.find(pfeed_item_id)
    klass = ar_obj_klass_name.constantize
    ar_obj = klass.find(ar_obj_id)
    pfeed_item.deliver(ar_obj, method_name_arr)

=begin
    # submit via email
    # comments & dashboard messages
    admin = Metadata::Setting.find_setting('site_notification_user')
    sender = User.find_by_fb_user_id(admin) || User.find_by_id(admin) || User.admins.last
    if sender and sender.email.present?
      pfeed_item.pfeed_deliveries.map(&:pfeed_receiver).each do |recipient|
        if recipient.accepts_email_notifications?
          #pfeed_item ... originator is the user
          #participant is a model element e.g. story
        	msg = recipient.message.build({
        	  :user => sender,
        	  :email => sender.email,
        	  :recipients = recipient.email,
        	  :subject = ,
            :message => ActionView::Base.new.render(:partial => "#{RAILS_ROOT}/app/views/reminders/email_signup.html.haml", :locals => { :user => recipient } ) 
        	})
        	recipient.message.push msg
        end
      end
    end
=end
  end
    
end