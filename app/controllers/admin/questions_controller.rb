class Admin::QuestionsController < AdminController
  skip_before_filter :admin_user_required
  
  def index
    @questions = Question.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      flash[:success] = "Successfully updated your Question ."
      redirect_to [:admin, @question]
    else
      flash[:error] = "Could not update your Question  as requested. Please try again."
      render :edit
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(params[:question])
    @question.user = current_user
    if @question.save
      flash[:success] = "Successfully created your new Question !"
      redirect_to [:admin, @question]
    else
      flash[:error] = "Could not create your Question , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'questions';
  end

end
