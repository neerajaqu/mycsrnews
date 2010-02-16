require 'open-uri'

class Image < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable

  belongs_to :user
  belongs_to :imageable, :polymorphic => true

  has_attached_file :image, :styles => {
  	:mini => "50x50#",
  	:thumb => "100x100#",
  	:small => "180x180>",
  	:medium => "200x200"
  }

  before_validation :download_image, :if => :remote_image_url?
  validates_presence_of :remote_image_url, :allow_blank => true, :message => 'invalid image or url.'

  def url options = {}
    self.image.url options
  end

  private

  def download_image
    self.image = open(URI.parse(remote_image_url))
  end

end
