class PredictionGuess < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_question, :counter_cache => true, :touch => true
  has_one :prediction_result
  acts_as_moderatable

  validates_presence_of :user, :prediction_question
  validate :validate_user_guess


  def user_guessed? user
    prediction_question.user_guessed? user
  end
  
  def expire
    self.class.sweeper.expire_prediction_guess_all self
  end

  def self.sweeper
    PredictionSweeper
  end

  private

  def validate_user_guess
    errors.add(:guess, "Invalid guess, please try again.") unless self.prediction_question.valid_guess? self.guess
  end
  
end
