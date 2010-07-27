class PredictionsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:my_predictions, :new, :create, :update, :like], :if => :request_comes_from_facebook?

  #cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index]
  before_filter :login_required, :only => [:like, :new, :create, :update]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Predict'
  end
  
  def next_prediction_group
    if PredictionGroup.count > 0
      @prediction_group = PredictionGroup.find(:first, :conditions => ["id > ?", params[:id] ], :order => "id asc")
      if @prediction_group.nil?
        flash[:success] = t('predictions.last_prediction')
        @prediction_group = PredictionGroup.first
      end
      redirect_to prediction_group_path(@prediction_group)
    else
      redirect_to prediction_groups_index_path
    end    
  end

  def previous_prediction_group
    if PredictionGroup.count > 0
      @prediction_group = PredictionGroup.find(:first, :conditions => ["id > ?", params[:id] ], :order => "id desc")
      if @prediction_group.nil?
        flash[:success] = t('predictions.that_was_first_prediction')
        @prediction_group = PredictionGroup.last
      end
      redirect_to prediction_group_path(@prediction_group)
    else
      redirect_to prediction_groups_index_path
    end    
  end
  
  def scores
    @current_sub_tab = 'Scores'
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @prediction_scores = PredictionScore.top.paginate :page => params[:page], :per_page => PredictionScore.per_page, :order => "accuracy desc"
    respond_to do |format|
      format.html { @paginate = false }
      format.json { @users = User.refine(params) }
    end
  end
  
  def new
  end

  def create
  end

  def my_predictions
    @paginate = true
    @current_sub_tab = 'Yours'
    @user = User.find(current_user)
    @prediction_guesses = @user.prediction_guesses.active.paginate :page => params[:page], :per_page => PredictionGuess.per_page, :order => "created_at desc"
  end

  private

#  def set_resource_section
#     @resource_section = params[:resource_section_id].present? ? ResourceSection.find(params[:resource_section_id]) : nil
#  end
   
  def set_current_tab
    @current_tab = 'predictions'
  end
end
