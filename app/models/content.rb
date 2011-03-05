class Content < ActiveRecord::Base

  acts_as_featured_item
  acts_as_media_item
  acts_as_moderatable
  acts_as_refineable
  acts_as_relatable
  acts_as_scorable
  acts_as_taggable_on :tags, :sections
  acts_as_tweetable
  acts_as_voteable
  acts_as_wall_postable
  acts_as_view_object
  
  belongs_to :user
  belongs_to :article
  belongs_to :newswire
  belongs_to :source
  has_one :content_image
  has_many :comments, :as => :commentable  

  has_friendly_id :title, :use_slug => true

  named_scope :published, { :joins => "LEFT JOIN articles on contents.article_id = articles.id", :conditions => ["contents.is_blocked =0 and (article_id is NULL OR (article_id IS NOT NULL and articles.is_draft = 0))"] }
  named_scope :unpublished, { :joins => "LEFT JOIN articles on contents.article_id = articles.id", :conditions => ["contents.is_blocked =0 and (article_id is NULL OR (article_id IS NOT NULL and articles.is_draft = 1))"] }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :commented, :conditions => ["comments_count > 0"]
  named_scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :newest_stories, lambda { |*args| { :conditions => ["article_id IS NULL"], :order => ["created_at desc"], :limit => (args.first || 5)} }
  named_scope :articles, { :conditions => ["article_id is not null"] }
  named_scope :stories, { :conditions => ["article_id IS NULL"], :order => ["created_at desc"]}
  named_scope :featured, lambda { |*args| { :conditions => ["contents.is_featured = 1"], :limit  => (args.first || 5) } }

  attr_accessor :image_url, :tags_string, :is_draft

  validates_presence_of :title, :caption, :user_id
  validates_presence_of :url, :if =>  :is_content?
  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :image_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :allow_blank => true, :message => "should look like a URL"
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."

  before_save :set_source, :if => :is_content?
  after_save :set_published, :if => :is_newswire?

  def set_source
    return true unless source_id.nil?
    begin
      domain = URI.parse(self.url).host.gsub("www.","")
      self.source = Source.find_by_url(domain)      
      unless source
        self.source = Source.create({
            :name => domain,
            :url => domain
        })
      end
    rescue 
    end
    return true
  end
  
  def set_published
    return false unless self.is_newswire?

    self.newswire.set_published
  end

  def is_article?
    self.article.present?
  end

  def is_newswire?
    self.newswire.present?
  end

  def is_content?
    not is_article? and not is_newswire?
  end

  def self.per_page
    10
  end

  def featured_url
    { :controller => '/stories', :action => 'show', :id => self }
  end

  # Remove this?
  def to_s
    self.title
  end

  def toggle_featured
    if is_article?
    	self.article.toggle_featured
    else
      self.is_featured = ! self.is_featured
      self.featured_at = Time.now if self.respond_to? 'featured_at'
      self.save
    end
  end

  def toggle_blocked
    if is_article?
      self.article.is_blocked = !self.article.is_blocked
      self.is_blocked = !self.is_blocked
      self.cascade_block self.is_blocked
      self.save
    else
      self.is_blocked = !self.is_blocked
      self.cascade_block self.is_blocked
      self.save
    end
  end

  def full_html?
    self.story_type == 'full_html'
  end

  def model_score_name
    is_article? ? "article" : "story"
  end

  def scorable_user
    is_article? ? article.author : user
  end

  def self.tweet_setting_group
    'stories'
  end
  
  def expire
    self.class.sweeper.expire_story_all self
  end

  def self.expire_all
    self.sweeper.expire_story_all self.new
  end

  def self.sweeper
    StorySweeper
  end

  def self.view_object_methods
    {
      :published => {
        :args => []
      },
      :newest => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      },
      :top => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      },
      :newest_stories => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      },
      :newest_articles => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      },
      :articles => {
        :args => []
      },
      :draft_articles => {
        :args => []
      },
      :top_articles => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      },
      :stories => {
        :args => []
      },
      :featured => {
        :args => [
          Newscloud::Acts::ViewObject.default_args_count
        ]
      }
    }
  end

  def model_index_name() "Stories" end
  def model_index_url_name() "stories_url" end
  def self.model_index_name() "Stories" end
  def self.model_index_url_name() "stories_url" end

end
