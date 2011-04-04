class PredictionQuestion < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags
  acts_as_featured_item
  acts_as_moderatable
  acts_as_wall_postable
  acts_as_tweetable

  serialize :choices

  belongs_to  :user
  belongs_to  :prediction_group, :counter_cache => true, :touch => true
  has_many    :prediction_guesses
  has_many  :correct_prediction_guesses, :class_name => "PredictionGuess", :conditions => [ "is_correct = 1"]
  has_many  :prediction_results

  attr_accessor :tags_string
  attr_accessor :list_of_choices, :start_range, :end_range

  has_friendly_id :title, :use_slug => true
  validate :validate_choices
  validate :validate_prediction_type
  validates_presence_of :title
  # TODO:: fix this, fails on text with [].present?
  #validates_presence_of :choices
  validates_presence_of :status

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["prediction_guesses_count desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :currently_open, lambda { |*args| { :conditions => ["status = 'open'" ] } }
  named_scope :approved, :conditions => { :is_approved => true }
  #todo add migration for timestamp closed_at
  named_scope :closed, lambda { |*args| { :order => ["status = 'closed', updated_at desc"], :limit => (args.first || 7)} }

  def validate_choices
    return true unless self.new_record? or self.list_of_choices.present? or self.start_range.present? or self.end_range.present?
    case self.prediction_type
      when 'multi'
        unless list_of_choices =~ /^([-a-zA-Z0-9_ ]+,?)+$/
          errors.add(:list_of_choices, 'Please provide a comma separated list of options')
        else
          self.choices = list_of_choices.split(',').map(&:strip)
        end
      when 'text'
        self.choices = []
      when 'yesno'
        self.choices = ['yes', 'no']
      when 'numeric'
        unless start_range.present? and end_range.present?
          errors.add(:start_range, 'Please provide a valid numeric start range') unless start_range.present? 
          errors.add(:end_range, 'Please provide a valid numeric end range') unless end_range.present? 
        else
          errors.add(:start_range, 'Start range must be a numeric value') unless start_range =~ /^[0-9]+$/
          errors.add(:end_range, 'End range must be a numeric value') unless end_range =~ /^[0-9]+$/
          errors.add(:end_range, 'End range must be greater than start range') unless end_range.to_i > start_range.to_i
        end
        unless errors.any?
          self.choices = {
          	:start_range => start_range,
          	:end_range => end_range
          }
        end
      when 'year'
        unless start_range.present? and end_range.present?
          errors.add(:start_range, 'Please provide a valid numeric start year') unless start_range.present? 
          errors.add(:end_range, 'Please provide a valid numeric end year') unless end_range.present? 
        else
          errors.add(:start_range, 'Start year must be a valid year') unless start_range =~ /^[0-9]{4}$/
          errors.add(:end_range, 'End year must be a valid year') unless end_range =~ /^[0-9]{4}$/
          errors.add(:end_range, 'End year must be greater than start year') unless end_range.to_i > start_range.to_i
        end
        unless errors.any?
          self.choices = {
          	:start_range => start_range,
          	:end_range => end_range
          }
        end
    end
  end

  def validate_prediction_type
      errors.add(:prediction_type, 'Please select a valid question type') unless self.class.prediction_types.keys.include? prediction_type
  end
  
  def self.prediction_types
      { 'multi' => 'multiple choice', 
        'yesno' => 'yes or no',
        'year' => 'year',
        'numeric' => 'number',
        'text' => 'text'
        }
  end

  def self.prediction_type_options
    self.prediction_types.collect {|k,v| [v.titleize, k] }
  end

  def valid_guess? guess
    case self.prediction_type
      when 'multi'
        self.choices.include? guess
      when 'yesno'
        self.choices.include? guess
      when 'year'
        start_year = self.choices[:start_range].to_i
        end_year = self.choices[:end_range].to_i
        start_year <= guess.to_i and guess.to_i <= end_year
      when 'numeric'
        start_range = self.choices[:start_range].to_f
        end_range = self.choices[:end_range].to_f
        start_range <= guess.to_f and guess.to_f <= end_range
      when 'text'
        guess.present?
      else
      	false
    end
  end


  def prediction_choice_options
    case self.prediction_type
      when 'multi'
        self.choices.collect {|k| [k.titleize, k] }
      when 'yesno'
        self.choices.collect {|k| [k.titleize, k] }
      when 'year'
        start_year = self.choices[:start_range].to_i
        end_year = self.choices[:end_range].to_i
        (start_year..end_year).to_a.collect {|y| [y, y] }
      else
      	[]
    end
  end
  
  def user_guessed? user
    prediction_guesses.exists?(:user_id => user.id)
  end

  def get_guess_totals
    @get_prediction_guess_totals ||= prediction_guesses.count
  end

  def get_guess_percentages
    get_guess_counts.collect do |g|
      {
        :guess    => g.guess,
        :percent  => (100.0 * g.count.to_f / get_guess_totals),
        :users => self.prediction_guesses.find(:all, :conditions => [ "guess = ?",g.guess], :include => :user,:order => 'rand()', :limit => 10 )
      }
    end
  end

  def get_guess_counts
    prediction_guesses.find(:all, :select => 'count(*) count, guess, prediction_question_id', :group => 'guess', :limit => 10, :order => "count desc")
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
    self.update_attribute(:status, "closed")
    # to do - update prediction group question count
    update_scores
    #todo - send notifications
    #Notifier.deliver_prediction_question_message(prediction_result.prediction_question)
    # TRIGGER NOTIFICATION ON USER
    # NEED AN ASSOCIATED USER TO ACCEPTING THE ANSWER
    # user.trigger_accepted_prediction_question(self)
  end
  
  def update_scores
    self.prediction_guesses.each do |prediction_guess|
      prediction_guess.user.get_prediction_score.increment_score prediction_guess.is_correct?
    end
  end

  def approve!
    @prediction_question.update_attribute(:is_approved, true)
  end  

  def voices
    self.prediction_guesses.find(:all, :include => :user, :group => :user_id).map(&:user)
  end

  def recipient_voices
    users = self.voices
    users << self.user
    # add people who liked group that the question is in
    users.concat self.prediction_group.votes.map(&:voter) 
    users.uniq
  end
  
  def expire
    self.class.sweeper.expire_prediction_question_all self
  end

  def self.sweeper
    PredictionSweeper
  end

  def get_accepted_result
    self.prediction_results.find(:first, :conditions => "is_accepted = 1")
  end
end
