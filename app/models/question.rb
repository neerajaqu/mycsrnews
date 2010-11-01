class Question < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable

  belongs_to  :user
  has_many    :answers
  has_one :tweeted_item, :as => :item

  validates_presence_of :question

  attr_accessor :tags_string

  named_scope :top, lambda { |*args| { :order => ["(2*answers_count+votes_tally) desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :unanswered, lambda { |*args| { :conditions => ["answers_count = 0"], :order => ["created_at asc"], :limit => (args.first || 10) } }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  def self.per_page; 20; end

  def self.get_top
    self.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
  end

  def self.valid_refine_type? value
    ['newest', 'top', 'unanswered'].include? value.downcase
  end

  def self.refineable_select_options
    ['Newest', 'Top', 'Unanswered'].collect { |k| [k, k] }
  end

  def featured_related_count
    self.answers_count
  end

  def featured_related_locale
    'answers_label'
  end

  def item_description
    details.present? ? details : item_title
  end

end
