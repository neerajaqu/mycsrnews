class PredictionGuess < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_question
  acts_as_moderatable

  #validates_presence_of 
end
