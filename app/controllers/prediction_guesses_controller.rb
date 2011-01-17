class PredictionGuessesController < ApplicationController
  before_filter :login_required, :only => [:new, :create]
  cache_sweeper :prediction_sweeper, :only => [:create, :update, :destroy]

  def create
    @prediction_question = PredictionQuestion.find(params[:prediction_question_id])
    if @prediction_question.user_guessed?(current_user)
      respond_to do |format|
        format.html do
          flash[:error] = "You already guessed on this question"
          redirect_to @prediction_question.prediction_group
        end
        format.json {  }
      end
    else
      # validate that user hasn't already guessed
      @prediction_guess = @prediction_question.prediction_guesses.build(params[:prediction_guess])
      @prediction_guess.user = current_user
      if params[:from_groups] and params[:from_groups] == 'true'
        redirect_object = @prediction_question.prediction_group
      else
        redirect_object = @prediction_question
      end
      if @prediction_guess.save
        respond_to do |format|
          #todo - if no prediction group, send to prediction question
          format.html {  redirect_to redirect_object }
          format.json {  render(:partial => 'shared/prediction_question_stats.html', :locals => { :prediction_question => @prediction_question }) and return }
        end
      else
        #todo - conditionally redirect to topic or question based on which page guess came from
        respond_to do |format|
          format.html do
            flash[:error] = "Could not submit your guess, please try again."
            redirect_to redirect_object
          end
          format.json { }
        end
      end
    end
  end

end
