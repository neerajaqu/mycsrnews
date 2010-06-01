class Forum < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable

  has_many :topics, :order => 'sticky desc, replied_at desc', :dependent => :destroy
  has_many :recent_topics, :class_name => "Topic", :order => 'replied_at desc'
  has_many :posts, :through => :topics

  has_friendly_id :name, :use_slug => true

  named_scope :positioned, :order => ["position desc, created_at desc"]

  validates_presence_of :name, :description

end
