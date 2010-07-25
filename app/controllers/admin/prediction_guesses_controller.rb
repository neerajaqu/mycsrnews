class Admin::PredictionGuessesController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => PredictionGuess.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => PredictionGuess,
    	:fields => [:prediction_question, :user, :guess, :guess_numeric, :guess_date, :created_at],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_question => :prediction_question_id } },
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @prediction_guess = PredictionGuess.find(params[:id])

    render_edit @prediction_guess
  end

  def update
    @prediction_guess = PredictionGuess.find(params[:id])
    if @prediction_guess.update_attributes(params[:prediction_guess])
      flash[:success] = "Successfully updated your PredictionGuess."
      redirect_to [:admin, @prediction_guess]
    else
      flash[:error] = "Could not update your PredictionGuess as requested. Please try again."
      render_edit @prediction_guess
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => PredictionGuess.find(params[:id]),
    	:model => PredictionGuess,
    	:fields => [:prediction_question, :user, :guess, :guess_numeric, :guess_date],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_question => :prediction_question_id } }
    }
  end

  def create
    @prediction_guess = PredictionGuess.new(params[:prediction_guess])
    if @prediction_guess.save
      flash[:success] = "Successfully created your new PredictionGuess!"
      redirect_to [:admin, @prediction_guess]
    else
      flash[:error] = "Could not create your PredictionGuess, please try again"
      render_new @prediction_guess
    end
  end

  def destroy
    @prediction_guess = PredictionGuess.find(params[:id])
    @prediction_guess.destroy

    redirect_to admin_prediction_guesses_path
  end

  private

  def render_new prediction_guess = nil
    prediction_guess ||= PredictionGuess.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @prediction_guess,
    	:model => PredictionGuess,
    	:fields => [:prediction_question, :user, :guess, :guess_numeric, :guess_date],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_question => :prediction_question_id } }
    }
  end

  def render_edit prediction_guess
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => prediction_guess,
    	:model => PredictionGuess,
    	:fields => [:prediction_question, :user, :guess, :guess_numeric, :guess_date],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_question => :prediction_question_id } }
    }
  end

  def set_current_tab
    @current_tab = 'prediction_guesses';
  end

end
