class Resource < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }

  belongs_to :user
  belongs_to :resource_section
  has_many :comments, :as => :commentable
  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_presence_of :url
  validates_presence_of :resource_section
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."
end