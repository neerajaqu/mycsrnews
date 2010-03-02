class Article < ActiveRecord::Base
  has_one :content
  belongs_to :author, :class_name => "User"

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
#TODO  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  accepts_nested_attributes_for :content

  validates_presence_of :body
end
