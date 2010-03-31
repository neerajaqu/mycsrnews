class QuestionsController < ApplicationController

  before_filter :login_required, :only => [:like, :new, :create, :create_answer]

  def index
    @current_sub_tab = 'Browse Questions'
    respond_to do |format|
      format.html
      format.fbml
      format.json { @questions = Question.refine(params) }
      format.fbjs { @questions = Question.refine(params) }
    end
  end

  def show
    @question = Question.find(params[:id])
    @answer   = Answer.new
  end

  def new
    @current_sub_tab = 'Ask Question'
  end

  def create
    @question = Question.new(params[:question])
    @question.user = current_user
    if @question.save
      flash[:success] = "Successfully posted your question!"
      redirect_to question_path(@question)
    else
    	flash[:error] = "Could not create your question. Please clear the errors and try again."
    	render :new
    end
  end

  def new_answer
  end

  def my_questions
    @current_sub_tab = 'My Questions'
    @user = User.find(params[:id])
    @questions = @user.questions
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

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'questions')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'questions')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'questions')
  end

  private

  def set_current_tab
    @current_tab = 'questions'
  end

end
