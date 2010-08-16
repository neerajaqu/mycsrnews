class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false

  has_many :contents
  has_many :audios
  has_many :images
  has_many :videos
  
end
