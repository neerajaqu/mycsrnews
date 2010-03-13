class Answer < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable

  belongs_to  :user
  belongs_to  :question, :counter_cache => true, :touch => true
  has_many    :comments, :as => :commentable

  validates_presence_of :answer

  named_scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }

  def self.get_top
    self.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
  end

end
