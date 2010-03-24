class Card < ActiveRecord::Base

  def image_path
    "cards/#{self.slug_name}.png"
  end

end
