class PredictionResultsController < ApplicationController
  def new
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    @prediction_result = PredictionResult.new
  end

  def create
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    @prediction_result = @prediction_question.prediction_results.build(params[:prediction_result])
    @prediction_result.user = current_user
    if @prediction_result.save
      respond_to do |format|
        format.html {  
    	    flash[:success] = "Thank you for letting us know!"
          redirect_to @prediction_question.prediction_group 
          }
        format.json {  }
      end
    else
      #todo - sometimes nil prediction group
      redirect_to @prediction_question.prediction_group 
    end
  end
end
