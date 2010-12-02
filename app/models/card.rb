class Card < ActiveRecord::Base
  acts_as_moderatable


  has_many :sent_cards

  def image_path
    "cards/#{self.slug_name}.png"
  end

  def already_sent_to sender
    list = sent_cards.sent_by sender.id
    list.map {|k| k.to_fb_user_id}.uniq.join ','
  end

  def expire
    self.class.sweeper.expire_card_all self
  end

  def self.expire_all
    self.sweeper.expire_card_all self.new
  end

  def self.sweeper
    CardSweeper
  end

end
