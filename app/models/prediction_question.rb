class PredictionQuestion < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags
  acts_as_featured_item
  acts_as_moderatable
  acts_as_wall_postable
  acts_as_tweetable

  belongs_to  :user
  belongs_to  :prediction_group, :counter_cache => true, :touch => true
  has_many    :prediction_guesses

  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true
  validates_presence_of :title
  validates_presence_of :choices
  validates_presence_of :status

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["guesses_count desc, created_at desc"], :limit => (args.first || 10)} }

  def user_guessed? user
    prediction_guesses.exists?(:user_id => user.id)
  end

  def update_stats
    case self.prediction_type
      when "yesno"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
      when "multi"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
    end    
  end
end
