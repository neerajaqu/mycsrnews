class RelatedItem < ActiveRecord::Base
  #acts_as_moderatable
  
  belongs_to :user
  belongs_to :relatable, :polymorphic => true

  validates_presence_of :title, :allow_blank => false
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
end
