class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    Notifier.deliver_contact_us_message(message)
  end
end
