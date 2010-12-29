class PredictionGuessesController < ApplicationController
  before_filter :login_required, :only => [:create]
  cache_sweeper :prediction_sweeper, :only => [:create, :update, :destroy]

  def create
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    if @prediction_question.user_guessed?(current_user)
      respond_to do |format|
        format.html {  redirect_to @prediction_question.prediction_group }
        format.json {  }
      end
    end
    # validate that user hasn't already guessed
    @prediction_guess = @prediction_question.prediction_guesses.build(params[:prediction_guess])
    @prediction_guess.user = current_user
    if @prediction_guess.save
      respond_to do |format|
        #todo - if no prediction group, send to prediction question
        format.html {  redirect_to @prediction_question.prediction_group }
    	  format.json {  render(:partial => 'shared/prediction_question_stats.html', :locals => { :prediction_question => @prediction_question }) and return }
      end
    else
      #todo - conditionally redirect to topic or question based on which page guess came from
    	redirect_to @prediction_question.prediction_group
    end
  end

end
