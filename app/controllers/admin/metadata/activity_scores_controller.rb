class Admin::Metadata::ActivityScoresController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::ActivityScore.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata::ActivityScore,
    	:fields => [:activity_score_name, :activity_score_sub_type_name, :activity_score_value],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @activity_score = Metadata::ActivityScore.find(params[:id])

    render_edit @activity_score
  end

  def update
    @activity_score = Metadata::ActivityScore.find(params[:id])
    #@activity_score.data = params[:custom_data].symbolize_keys
    if @activity_score.update_attributes(params[:metadata_activity_score])
      # sweep cache elements when specific activity_scores change
      if @activity_score.key_name.include? "welcome_"
        WidgetSweeper.expire_item "welcome_panel"
      end
      flash[:success] = "Successfully updated your activity_score."
      redirect_to admin_metadata_activity_score_path(@activity_score)
    else
      flash[:error] = "Could not update your activity_score as requested. Please try again."
      render_edit @activity_score
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::ActivityScore.find(params[:id]),
      :model => Metadata::ActivityScore,
    	:fields => [:activity_score_name, :activity_score_sub_type_name, :activity_score_value, :activity_score_hint, :created_at],
    }
  end

  def create
    @activity_score = Metadata::ActivityScore.new(params[:metadata_activity_score])
    if @activity_score.save
      flash[:success] = "Successfully created your activity_score."
      redirect_to admin_metadata_activity_score_path(@activity_score)
    else
      flash[:error] = "Could not create your activity_score as requested. Please try again."
      render_new @activity_score
    end
  end

  def destroy
    @activity_score = Metadata::ActivityScore.find(params[:id])
    @activity_score.destroy

    redirect_to admin_metadata_activity_scores_path
  end

  private

  def render_new activity_score = nil
    activity_score ||= Metadata::ActivityScore.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => activity_score,
    	:model => Metadata::ActivityScore,
    	:fields => [:activity_score_name, :activity_score_hint, lambda {|f| f.input :activity_score_sub_type_name, :required => false }, :activity_score_value]
    }
  end

  def render_edit activity_score
    activity_score ||= Metadata::ActivityScore.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => activity_score,
    	:model => Metadata::ActivityScore,
    	:fields => [lambda {|f| f.input :activity_score_value, :label => t('score_for', :activity => activity_score.activity_score_name), :hint => activity_score.activity_score_hint },]
    }
  end

  def set_current_tab
    @current_tab = 'activity_scores';
  end

end
