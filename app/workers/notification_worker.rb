class NotificationWorker
  @queue = :notifications

  # Takes a PfeedItem and stringified PfeedItem.attemp_delivery method params
  def self.perform(pfeed_item_id, ar_obj_klass_name, ar_obj_id, method_name_arr)
    pfeed_item = PfeedItem.find(pfeed_item_id)
    klass = ar_obj_klass_name.constantize
    ar_obj = klass.find(ar_obj_id)
    pfeed_item.deliver(ar_obj, method_name_arr)
    # todo - send_email_with(pfeed_item)  
  end

end
