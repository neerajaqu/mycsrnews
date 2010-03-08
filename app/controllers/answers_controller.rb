class AnswersController < ApplicationController
  
  def show
    @answer = Answer.find(params[:id])
    redirect_to @answer.question
  end

end
