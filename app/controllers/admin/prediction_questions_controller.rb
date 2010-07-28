class Admin::PredictionQuestionsController < AdminController

  before_filter :set_prediction_types 
  
  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => PredictionQuestion.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => PredictionQuestion,
    	:fields => [:title, :prediction_type, :status, :created_at],
    	:associations => { :belongs_to => { :user => :user_id } },
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @prediction_question = PredictionQuestion.find(params[:id])

    render_edit @prediction_question
  end

  def update
    @prediction_question = PredictionQuestion.find(params[:id])
    if @prediction_question.update_attributes(params[:prediction_question])
      flash[:success] = "Successfully updated your PredictionQuestion."
      redirect_to [:admin, @prediction_question]
    else
      flash[:error] = "Could not update your PredictionQuestion as requested. Please try again."
      render_edit @prediction_question
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => PredictionQuestion.find(params[:id]),
    	:model => PredictionQuestion,
    	:fields => [:title, :prediction_type, :status, :is_approved, :is_blocked, :user_id, :prediction_group_id],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_group => :prediction_group_id } }
    }
  end

  def create
    @prediction_question = PredictionQuestion.new(params[:prediction_question])
    if @prediction_question.save
      flash[:success] = "Successfully created your new PredictionQuestion!"
      redirect_to [:admin, @prediction_question]
    else
      flash[:error] = "Could not create your PredictionQuestion, please try again"
      render_new @prediction_question
    end
  end

  def destroy
    @prediction_question = PredictionQuestion.find(params[:id])
    @prediction_question.destroy

    redirect_to admin_prediction_questions_path
  end

  private

  def render_new prediction_question = nil
    prediction_question ||= PredictionQuestion.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @prediction_question,
    	:model => PredictionQuestion,
    	:fields => [:title, lambda {|f| f.input :prediction_type, :as => :select, :collection => @type_list}, lambda {|f| f.input :choices, :required => false }, :status, :is_approved, :is_blocked, :user_id, :prediction_group_id],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_group => :prediction_group_id } }
    }
  end

  def render_edit prediction_question
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => prediction_question,
    	:model => PredictionQuestion,
    	:fields => [:title, lambda {|f| f.input :prediction_type, :as => :select, :collection => @type_list}, lambda {|f| f.input :choices, :required => false } , :status, :is_approved, :is_blocked, :user_id, :prediction_group_id, :created_at],
    	:associations => { :belongs_to => { :user => :user_id , :prediction_group => :prediction_group_id } }
    }
  end

  def set_prediction_types
    @type_list = { t('predictions.types.yes_no') => 'yesno', t('predictions.types.multi') => 'multi',  t('predictions.types.numeric') => 'numeric', t('predictions.types.text') => 'text', t('predictions.types.year') => 'year' }
  end
  
  def set_current_tab
    @current_tab = 'prediction_questions';
  end

end
