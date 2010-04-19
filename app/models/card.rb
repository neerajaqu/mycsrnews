class Card < ActiveRecord::Base

  has_many :sent_cards

  def image_path
    "cards/#{self.slug_name}.png"
  end

  def already_sent_to sender
    list = sent_cards.sent_by sender.id
    list.map {|k| k.to_fb_user_id}.uniq.join ','
  end

end
