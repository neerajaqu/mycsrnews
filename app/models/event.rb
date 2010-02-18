class Event < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }

  belongs_to :user

  has_many :comments, :as => :commentable
  attr_accessor :tags_string

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."
  
end

