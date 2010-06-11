class PfeedDelivery < ActiveRecord::Base
  belongs_to :pfeed_receiver, :polymorphic => true
  belongs_to :pfeed_item

  after_create :trigger_receiver_delivery_callback

  private

  def trigger_receiver_delivery_callback
    if self.pfeed_receiver.respond_to? "pfeed_trigger_delivery_callback"
    	self.pfeed_receiver.pfeed_trigger_delivery_callback self.pfeed_item
    end
  end

end
