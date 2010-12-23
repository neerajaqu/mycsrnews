class PredictionGuessesController < ApplicationController
  before_filter :login_required, :only => [:create]
  #cache_sweeper :prediction_sweeper, :only => [:create, :update, :destroy]

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
        format.html {  redirect_to @prediction_question.prediction_group }
        format.json {  }
      end
    else
      raise params.inspect
    end

  end

end
