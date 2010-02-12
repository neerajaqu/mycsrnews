class Feed < ActiveRecord::Base
  has_many :newswires

  def to_s
    self.title
  end

end
