class FlagObserver < ActiveRecord::Observer
  def after_create(flag)
    Notifier.deliver_flag_message(flag)
  end
end
