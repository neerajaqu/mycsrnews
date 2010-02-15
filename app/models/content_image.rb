class ContentImage < ActiveRecord::Base
  belongs_to :content

  def to_s
    self.url
  end

end
