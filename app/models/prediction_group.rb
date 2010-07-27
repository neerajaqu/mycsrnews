class PredictionGroup < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable

  belongs_to  :user
  has_many    :prediction_questions
  has_one :tweeted_item, :as => :item
  has_many :comments, :as => :commentable

  attr_accessor :tags_string


  has_friendly_id :title, :use_slug => true
  validates_presence_of :title, :section

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }

  def to_s
    "Prediction Group: #{title}"
  end

  def next
    if PredictionGroup.count > 0
      PredictionGroup.find(:first, :conditions => ["id > ?", self.id ], :order => "id asc")
    else
      nil
    end
  end
  
  def previous
    if PredictionGroup.count > 0
      PredictionGroup.find(:first, :conditions => ["id < ?", self.id ], :order => "id desc")
    else
      nil
    end
  end

end
