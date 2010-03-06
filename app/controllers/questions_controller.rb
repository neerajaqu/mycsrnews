class QuestionsController < ApplicationController

  before_filter :login_required, :only => [:like, :new, :create, :create_answer]

  def index
    @questions = Question.newest
  end

  def show
    @question = Question.find(params[:id])
    @answer   = @question.answers.build
    if request.post?
    	raise params.inspect
    end
  end

  def new
  end

  def create
  end

  def new_answer
  end

  def create_answer
    raise params.inspect
  end

end
