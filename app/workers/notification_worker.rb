class NotificationWorker
  @queue = :notifications

  # Takes a PfeedItem and stringified PfeedItem.attemp_delivery method params
  def self.perform(pfeed_item_id, ar_obj_klass_name, ar_obj_id, method_name_arr)
    pfeed_item = PfeedItem.find(pfeed_item_id)
    klass = ar_obj_klass_name.constantize
    ar_obj = klass.find(ar_obj_id)
    pfeed_item.deliver(ar_obj, method_name_arr)
=begin        
    pfeed_item ... originator is the user
      participant is a model element e.g. story
      
    # deliver as email message
    # check that target user has an email address and notification turned on
    pfeed_item.pfeed_deliveries.map(&:pfeed_receiver).each do |user|
    	@message = Message.new()
    	# set sender as admin or site
    	@message.user = !!!sending admin user!!!??
    	@message.email = !!!sending admin user!!!??
    	# set recipient
    	@message.recipients = recipient
      # construct a notification from view and delivery via email
    	@message.subject =
    	@message.message = 
    end
=end
  end
  
end
