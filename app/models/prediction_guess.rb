class PredictionGuess < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_question, :counter_cache => true, :touch => true
  has_one :prediction_result
  acts_as_moderatable

  #validates_presence_of 

  def user_guessed? user
    prediction_question.user_guessed? user
  end
  
  def expire
    self.class.sweeper.expire_prediction_guess_all self
  end

  def self.sweeper
    PredictionSweeper
  end
  
end
