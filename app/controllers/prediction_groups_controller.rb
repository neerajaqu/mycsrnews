class PredictionGroupsController < ApplicationController
  before_filter :login_required, :only => [:like, :new, :create]
  before_filter :set_ad_layout, :only => [:index, :show]

#  cache_sweeper :qanda_sweeper, :only => [:create, :update, :destroy, :create_answer]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @prediction_groups = PredictionGroup.paginate :page => params[:page], :per_page => PredictionGroup.per_page, :order => "created_at desc"    
    @current_sub_tab = 'Browse'
  end
  
  def show
    self.play    
  end
  
  def play
    if params[:id].nil?
      # to do - get first open
      @prediction_group = PredictionGroup.first
      #:all, :order => "rand()"
    else
      @prediction_group = PredictionGroup.find(params[:id])
    end
    tag_cloud @prediction_group
    set_outbrain_item @prediction_group
    @current_sub_tab = 'Predict'
    @previous_prediction_group = @prediction_group.previous
    @next_prediction_group = @prediction_group.next
    render :template => 'prediction_groups/show'
  end
    
end
