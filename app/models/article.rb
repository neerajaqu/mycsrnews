class Article < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable
  acts_as_relatable

  has_one :content
  has_one :tweeted_item, :as => :item
  belongs_to :author, :class_name => "User"

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["featured_at desc"], :limit => (args.first || 1)} }
  #named_scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :blog_roll, lambda { |*args| {  :group => [ "author_id"], :order => ["created_at desc"], :limit => (args.first || 30)} }

  accepts_nested_attributes_for :content

  validates_presence_of :body
  
  before_save :sanitize_body

  def item_title
    content.item_title
  end

  def item_description
    content.item_description
  end

  def item_link
    content
  end

  def toggle_blocked
    self.is_blocked = !self.is_blocked
    self.content.toggle_blocked
    return self.save ? true : false
  end  
        
  private
  
  def sanitize_body
    self.body = self.body.sanatize_standard
  end
end
