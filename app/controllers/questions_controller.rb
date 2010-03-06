class QuestionsController < ApplicationController

  before_filter :login_required, :only => [:like, :new, :create, :create_answer]

  def index
    @questions = Question.newest
  end

  def show
    @question = Question.find(params[:id])
    @answer   = Answer.new
  end

  def new
  end

  def create
  end

  def new_answer
  end

  def create_answer
    @question = Question.find(params[:id])
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @question.save
    	flash[:success] = "Thank you for posting your answer!"
    	redirect_to @question
    else
    	flash[:error] = "Could not create your question, please try again."
    	redirect_to @question
    end
  end

end
