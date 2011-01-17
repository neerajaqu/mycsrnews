class PredictionResultsController < ApplicationController
  before_filter :login_required, :only => [:new, :create]

  def new
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    @prediction_result = @prediction_question.prediction_results.build
  end

  def create
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    @prediction_result = @prediction_question.prediction_results.build(params[:prediction_result])
    @prediction_result.user = current_user
    if @prediction_result.save
      respond_to do |format|
        format.html do
    	    flash[:success] = "Thank you for letting us know!"
          redirect_to @prediction_question.prediction_group 
        end 
        format.json {  }
      end
    else
      respond_to do |format|
        format.html do
    	    flash[:error] = "Could not submit your result, please try again."
          render :new
        end 
        format.json {  }
      end
    end
  end
end
