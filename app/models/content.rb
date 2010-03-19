class Content < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable

  belongs_to :user
  belongs_to :article
  has_one :content_image
  has_many :comments, :as => :commentable

  has_friendly_id :title, :use_slug => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :newest_stories, lambda { |*args| { :conditions => ["article_id IS NULL"], :order => ["created_at desc"], :limit => (args.first || 5)} }
  named_scope :newest_articles, lambda { |*args| { :conditions => ["article_id IS NOT NULL"], :order => ["created_at desc"], :limit => (args.first || 5)} }

  attr_accessor :image_url, :tags_string

  validates_presence_of :title, :caption
  validates_presence_of :url, :if =>  :is_content?
  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :image_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :allow_blank => true, :message => "should look like a URL"
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."

  def self.top
    self.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
  end

  def is_article?
    self.article.present?
  end

  def is_content?
    ! is_article?
  end

  def self.per_page
    10
  end

  def get_image_url
    self.content_image.present? ? self.content_image.url : nil
  end

  def featured_url
    { :controller => '/stories', :action => 'show', :id => self }
  end

  def to_s
    self.title
  end

  def toggle_featured
    if is_article?
    	self.article.toggle_featured
    else
      self.is_featured = ! self.is_featured
      self.featured_at = Time.now
      self.save
    end
  end

  private
  
end
