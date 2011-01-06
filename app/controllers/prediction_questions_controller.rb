class PredictionQuestionsController < ApplicationController

  def new 
   @current_sub_tab = 'New Prediction Question'
   @prediction_question = PredictionQuestion.new
  end

  def create
    @prediction_question = PredictionQuestion.new(params[:prediction_question])
    @prediction_question.tag_list = params[:prediction_question][:tags_string]
    @prediction_question.user = current_user
    @prediction_question.is_approved = current_user.is_moderator?      

    if @prediction_question.valid? and current_user.prediction_questions.push @prediction_question
    	flash[:success] = t('predictions.create_prediction_question')
    	redirect_to predictions_path
    else
      @prediction_questions = PredictionQuestion.active.open.newest
    	render :new
    end
  end  

end
