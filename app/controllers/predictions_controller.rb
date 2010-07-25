class PredictionsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:your, :new, :create, :update, :like], :if => :request_comes_from_facebook?

  #cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index]
  before_filter :login_required, :only => [:like, :new, :create, :update]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse'
  end

  def your
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Yours'
    @user = current_user
    @guesses = @user.prediction_guesses.paginate :page => params[:page], :per_page => PredictionGuess.per_page, :order => "created_at desc"    
  end
  
  def scores
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Scores'
  end
  
  def new
  end

  def create
  end

  def yours
    @paginate = true
    @current_sub_tab = 'My Resources'
    @user = User.find(params[:id])
    @resources = @user.resources.active.paginate :page => params[:page], :per_page => Resource.per_page, :order => "created_at desc"
  end

  private

#  def set_resource_section
#     @resource_section = params[:resource_section_id].present? ? ResourceSection.find(params[:resource_section_id]) : nil
#  end
   
  def set_current_tab
    @current_tab = 'predictions'
  end
end
