class Admin::PredictionResultsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => PredictionResult.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => PredictionResult,
    	:fields => [:result, :prediction_question_id, :created_at],
    	:associations => { :belongs_to => { :user => :user_id, :prediction_question => :prediction_question_id } },
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @prediction_result = PredictionResult.find(params[:id])

    render_edit @prediction_result
  end

  def update
    @prediction_result = PredictionResult.find(params[:id])
    if @prediction_result.update_attributes(params[:prediction_result])
      flash[:success] = "Successfully updated your PredictionResult."
      redirect_to [:admin, @prediction_result]
    else
      flash[:error] = "Could not update your PredictionResult as requested. Please try again."
      render_edit @prediction_result
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => PredictionResult.find(params[:id]),
    	:model => PredictionResult,
    	:fields => [:result, :url, :details, :is_accepted, :user_id, :prediction_question_id, :created_at],
    	:associations => { :belongs_to => { :user => :user_id, :prediction_question => :prediction_question_id } }
    }
  end

  def create
    @prediction_result = PredictionResult.new(params[:prediction_result])
    if @prediction_result.save
      flash[:success] = "Successfully created your new PredictionResult!"
      redirect_to [:admin, @prediction_result]
    else
      flash[:error] = "Could not create your PredictionResult, please try again"
      render_new @prediction_result
    end
  end

  def destroy
    @prediction_result = PredictionResult.find(params[:id])
    @prediction_result.destroy

    redirect_to admin_prediction_results_path
  end
  
  def accept
    @prediction_result = PredictionResult.find(params[:id])
    unless @prediction_result
      flash[:error] = "Invalid prediction result"
      redirect_to admin_prediction_results_path
    end

    result = false
    if result =~ /^[0-9]+$/
      @dashboardMessage.set_success! result
      flash[:success] = "Successfully accepted this result"
      redirect_to admin_prediction_results_path
    else
    	flash[:error] = "Could not accept this result"
      redirect_to admin_prediction_results_path
    end
  end

  private

  def render_new prediction_result = nil
    prediction_result ||= PredictionResult.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @prediction_result,
    	:model => PredictionResult,
    	:fields => [:result, lambda {|f| f.input :details, :required => false }, :url, :is_accepted, :user_id, :prediction_question_id],
    	:associations => { :belongs_to => { :user => :user_id, :prediction_question => :prediction_question_id } }
    }
  end

  def render_edit prediction_result
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => prediction_result,
    	:model => PredictionResult,
    	:fields => [:result, lambda {|f| f.input :details, :required => false }, :url, :is_accepted, :user_id, :prediction_question_id],
    	:associations => { :belongs_to => { :user => :user_id, :prediction_question => :prediction_question_id } }
    }
  end

  def set_current_tab
    @current_tab = 'prediction_results';
  end

end
