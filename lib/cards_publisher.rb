class CardsPublisher < Facebooker::Rails::Publisher
  
  def notification(to, from, message)
    send_as :notification
    self.recipients(to)
    self.from(from)
    fbml message
  end

end
