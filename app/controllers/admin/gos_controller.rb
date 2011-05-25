class Admin::GosController < AdminController
  before_filter :set_goable_types

  admin_scaffold :go do |config|
    config.index_fields = [:name, :views_count, :goable, :user_id]
    #config.actions = [:index, :show, :edit, :update, :new, :create]
    config.actions = [:index]
    config.associations = { :belongs_to => { :user => :user_id, :goable => :goable } }
    config.new_fields = [:name, :goable_type, :goable_id]
    config.edit_fields = [:name, :goable_type, :goable_id]
  end

  def new
    @go = Go.new
  end

  def show
    @go = Go.find(params[:id])
  end

  def edit
    @go = Go.find(params[:id])
  end

  def create
    @go = Go.new
    @go.name = params[:go][:name]
    if @goable_types.map {|a| a[1].classify}.include? params[:go][:goable_type].classify and @goable = find_goable
      @go.goable = @goable
      if @go.save
        flash[:success] = "Successfully created your go link"
        redirect_to [:admin, @go]
      else
        flash[:error] = "Could not create your go link"
        render :new
      end
    else
      flash[:error] = "Invalid item type, please select a valid item from the right column"
      render :new
    end
  end

  private

    def set_goable_types
      @goable_types ||= [['Stories', 'contents'], ['Ideas', 'ideas'], ['Idea Boards', 'idea_boards'], ['Questions', 'questions'], ['Resources', 'resources'], ['Resource Sections', 'resource_sections'], ['Events', 'events'], ['Galleries', 'galleries'], ['Forums', 'forums'], ['Topics', 'topics'], ['Prediction Groups', 'prediction_groups'], ['Prediction Questions', 'prediction_questions'], ['Videos', 'videos']]
    end

    def find_goable
      return nil unless params[:go]
      return params[:go][:goable_type].classify.constantize.find_by_id(params[:go][:goable_id])
    end

end
