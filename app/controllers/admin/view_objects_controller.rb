class Admin::ViewObjectsController < AdminController
  before_filter :set_featured_types, :only => [:edit, :update]

  admin_scaffold :view_object do |config|
    config.index_fields = [:name, :view_object_template_id]
    config.show_fields = [:name, :view_object_template_id]
    config.actions = [:index, :show]
    config.associations = { :belongs_to => { :view_object_template => :view_object_template_id } }
  end

  def edit
    @view_objects = ["v2_double_col_feature_triple_item", "v2_double_col_triple_item", "v2_triple_col_large_2"].map {|name| ViewObjectTemplate.find_by_name(name) }.map(&:view_objects).flatten.select {|vo| vo.setting.kommands.empty? }
    @view_object = ViewObject.find(params[:id])
    @view_object_template = @view_object.view_object_template

    unless @view_objects.include? @view_object
      flash[:error] = "Invalid view object"
      redirect_to admin_path and return
    end
  end

  def update
    data = params['featured_items']
    view_object = ViewObject.find(params[:id])

    render :json => {:error => "Invalid Type"}.to_json and return unless data.select {|i| not @featurables.map {|f| f[1].classify }.include?(i.sub(/-[0-9]+$/,'').classify) }.empty?

    view_object.setting.dataset = data.map {|i| i.split(/-/) }.map{|i| [i[0].classify, i[1]] }
    view_object.setting.save

    render :json => {:success => "Success!"}.to_json and return
  end

  private

    def set_featured_types
      @featurables ||= [['Stories', 'contents'], ['Ideas', 'ideas'], ['Questions', 'questions'], ['Resources', 'resources'], ['Events', 'events'], ['Galleries', 'galleries'], ['Forums', 'forums'], ['Topics', 'topics'], ['Prediction Groups', 'prediction_groups'], ['Prediction Questions', 'prediction_questions'], ['Videos', 'videos']]
    end

end
