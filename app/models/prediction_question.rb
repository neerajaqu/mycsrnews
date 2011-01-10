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
  has_many  :correct_prediction_guesses, :conditions => [ "is_correct = 1"]
  has_many  :prediction_results

  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true
  validates_presence_of :title
  validates_presence_of :choices
  validates_presence_of :status

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["guesses_count desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :open, lambda { |*args| { :order => ["status = 'open'" ]} }
  #todo add migration for timestamp closed_at
  named_scope :closed, lambda { |*args| { :order => ["status = 'closed', updated_at desc"], :limit => (args.first || 7)} }

  def self.prediction_types friendly
    unless friendly.nil?
      ['multiple choice','yes or no','year','foating point number','whole number e.g. integer','text']    
    else
      ['multi','yesno','year','float','numeric','text']
    end
  end

  def user_guessed? user
    prediction_guesses.exists?(:user_id => user.id)
  end

  def update_stats
    case self.prediction_type
      when "yesno"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
      when "multi"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
      when "numeric"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
      when "text"
        PredictionGuess.count(:group => :guess, :conditions => {:prediction_question_id => self.id})
    end
  end
  
  def accept_prediction_result prediction_result
    # all users who made the correct guess on the question
    # correct guess = when user guess = prediction_result.result
    correct_guesses = self.prediction_guesses.find(:all, :conditions => [ "guess = ?",prediction_result.result], :include => :user)
    correct_guesses.each do |prediction_guess|
      prediction_guess.update_attribute("is_correct",true)
    end
    update_scores
    #todo - send notifications
    #Notifier.deliver_prediction_question_message(prediction_result.prediction_question)
  end
  
  def update_scores
    self.prediction_guesses.each do |prediction_guess|
      prediction_guess.user.get_prediction_score.increment_score prediction_guess.is_correct?
    end
  end

  def approve
    @prediction_question = PredictionQuestion.find(params[:id])
    @prediction_question.is_approved = true
    if @prediction_question.update_attributes(params[:id])
  end  

  def voices
    self.prediction_guesses.find(:all, :include => :user, :group => :user_id).map(&:user)
  end

  def recipient_voices
    users = self.voices
    users << self.user
    # todo - get list of people who liked question prediction group
    #users.concat self.commentable.votes.map(&:voter) 
    users.uniq
  end
  
  def expire
    self.class.sweeper.expire_prediction_question_all self
  end

  def self.sweeper
    PredictionSweeper
  end

end
