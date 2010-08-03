class PredictionGuessesController < ApplicationController
  before_filter :login_required, :only => [:create]
  #cache_sweeper :prediction_sweeper, :only => [:create, :update, :destroy]

  def create
    raise params.inspect
    respond_to do |format|
      format.json { @prediction_question = PredictionQuestion(params[:prediction_question_id]) }
    end
    return @prediction_question.id
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    @comment.comments = @template.sanitize_user_content @comment.comments
    if @comment.save
      # to do doesn't work for topic replies
      if @comment.post_wall?
        session[:post_wall] = @comment
      end
    	# TODO:: change this to work with polymorphic associations, switch to using touch
    	#expire_page :controller => 'stories', :action => 'show', :id => @story
    	redirect_to @commentable
    else
    	redirect_to @commentable
    end
  end

end
