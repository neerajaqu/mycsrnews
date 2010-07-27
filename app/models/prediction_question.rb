class PredictionQuestion < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags
  acts_as_featured_item
  acts_as_moderatable
  acts_as_wall_postable

  belongs_to  :user
  belongs_to  :prediction_group
  has_many    :prediction_guesses
  has_one :tweeted_item, :as => :item

  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true
  validates_presence_of :title
  validates_presence_of :choices
  validates_presence_of :status

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["guesses_count desc, created_at desc"], :limit => (args.first || 10)} }

end
