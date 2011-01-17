class Admin::AnswersController < AdminController
  skip_before_filter :admin_user_required
  
  def index
    @answers = Answer.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @answer = Answer.new
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
    	@answer.expire
      flash[:success] = "Successfully updated your Answer ."
      redirect_to [:admin, @answer]
    else
      flash[:error] = "Could not update your Answer  as requested. Please try again."
      render :edit
    end
  end

  def show
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.user = current_user
    if @answer.save
      flash[:success] = "Successfully created your new Answer !"
      redirect_to [:admin, @answer]
    else
      flash[:error] = "Could not create your Answer , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'answers';
  end

end
