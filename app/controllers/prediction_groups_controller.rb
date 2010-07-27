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
    @prediction_group = PredictionGroup.find(params[:id])
    tag_cloud @prediction_group
    @current_sub_tab = 'Predict'
  end
  
  def self.next
    if PredictionGroup.count > 0
      @prediction_group = PredictionGroup.find(:first, :conditions => ["id > ?", params[:id] ], :order => "id asc")
      if @prediction_group.nil?
        @prediction_group = PredictionGroup.first
      end
      prediction_group_path(@prediction_group)
    else
      prediction_groups_index_path
    end    
  end
  
  def self.previous
    if PredictionGroup.count > 0
      @prediction_group = PredictionGroup.find(:first, :conditions => ["id > ?", params[:id] ], :order => "id desc")
      if @prediction_group.nil?
        flash[:success] = t('predictions.that_was_first_prediction')
        @prediction_group = PredictionGroup.last
      end
      redirect_to prediction_group_path(@prediction_group)
    else
      redirect_to prediction_groups_index_path
    end    end
  
end
