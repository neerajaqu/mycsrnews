class Resource < ActiveRecord::Base
  acts_as_voteable
  # has_many :comments
  acts_as_taggable_on :tags, :sections

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["likes_count desc"], :limit => (args.first || 10)} }

  belongs_to :user
  attr_accessor :tags_string

  validates_presence_of :title
  validates_presence_of :url
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."
  
end

