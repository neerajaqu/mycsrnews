class Feed < ActiveRecord::Base
  has_many :newswires
  belongs_to :user

  validates_presence_of :title
  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
  validates_format_of :rss, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false

  named_scope :roll, lambda { |*args| { :conditions => ["feedType != ? AND feedType != ?", 'images', 'bookmarks' ], :order => ["last_fetched_at desc"], :limit => (args.first || 7)} }
  named_scope :active, lambda { |*args| { :conditions => ["deleted_at is null" ] } }

  def to_s
    self.title
  end

  def full_html?
    self.loadOptions == 'full_html'
  end

end
