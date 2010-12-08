class AnswersController < ApplicationController
  
  def show
    @answer = Answer.active.find(params[:id])
    redirect_to @answer.question
  end

end
