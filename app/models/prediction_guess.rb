class PredictionGuess < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_questions

  #validates_presence_of 
end
