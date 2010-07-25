class PredictionGuess < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_questions
  acts_as_moderatable

  #validates_presence_of 
end
