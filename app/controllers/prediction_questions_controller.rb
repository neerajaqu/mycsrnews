class PredictionQuestionsController < ApplicationController

  def show
    #todo - change question link
    #todo - handle question with no group
    @prediction_question = PredictionQuestion.find(params[:id])
    redirect_to prediction_group_path(@prediction_question.prediction_group)
  end

  
  
end
