class Admin::WidgetsController < AdminController
  cache_sweeper :story_sweeper, :only => [:save]

  def index
    @main = Widget.main
    @sidebar = Widget.sidebar
    @page = WidgetPage.find_root_by_page_name('home')
    if @page.present? and @page.children.present?
      @main_widgets = @page.children.first.children
      @sidebar_widgets = @page.children.second.children
    else
    	@main_widgets = nil
    	@sidebar_widgets = nil
    end
  end

  def new_widgets
    @filters = [
      { :name => 'stories', :regex => /(stor(y|ies))|article|featured_content/i },
      { :name => 'content', :regex => /idea|question|answer|event|resource|forum|topic/i },
      { :name => 'media', :regex => /image|video|galler(y|ies)/i },
      { :name => 'users', :regex => /user?/i },
      { :name => 'ads', :regex => /\bad[s_\.]/i },
      { :name => 'misc', :regex => /.+/i }
    ]
    @controller = self
    @main = Widget.main
    @sidebar = Widget.sidebar
    @page = WidgetPage.find_root_by_page_name('home')
    if @page.present? and @page.children.present?
      @main_widgets = @page.children.first.children
      @sidebar_widgets = @page.children.second.children
    else
    	@main_widgets = []
    	@sidebar_widgets = []
    end
  end

  def newer_widgets
    @filters = [
      { :name => 'stories', :regex => /(stor(y|ies))|article|featured_content/i },
      { :name => 'content', :regex => /idea|question|answer|event|resource|forum|topic|newswire|classified/i },
      { :name => 'media', :regex => /image|video|galler(y|ies)/i },
      { :name => 'users', :regex => /user|welcome panel?/i },
      { :name => 'ads', :regex => /\bad[s_\. ]/i },
      { :name => 'misc', :regex => /.+/i }
    ]
    @page = ViewObject.find_by_name("home--index")
    @view_objects = ViewObject.find(:all, :conditions => ["view_object_template_id is not null"])
    @editable_view_objects = ["v2_double_col_feature_triple_item", "v2_double_col_triple_item", "v2_triple_col_large_2"].map {|name| ViewObjectTemplate.find_by_name(name) }.map(&:view_objects).flatten
    @main = Widget.main
    @sidebar = Widget.sidebar
    if @page.present? and @page.edge_children.present?
      @main_widgets = @page.edge_children
    else
    	@main_widgets = []
    end
  end

  def save_newer_widgets
    @page = ViewObject.find_by_name("home--index")
    children = []
    params[:main].split(/,/).reverse.each_with_index do |view_object_id, position|
      view_object = nil
      raise ArgumentError.new "Invalid id: #{view_object_id}" unless view_object_id =~ /^[0-9]+$/ and view_object = ViewObject.find(view_object_id)
      children.push ViewTreeEdge.new({ :parent => @page, :child => view_object, :position => position + 1 })
    end
    @page.direct_view_tree_edges.destroy_all
    children.map(&:save)
    render :json => {:success => "Success!"}.to_json and return
  end

  def save
    # TODO:: Switch to updating instead of deleting
    WidgetPage.destroy_all
    @main = params[:main].split /,/
    @sidebar = params[:sidebar].split /,/

    @home_page = WidgetPage.create({:name => 'home'})
    @main_content = @home_page.children.create({:name => "home_main_content", :widget_type => "main_content"})
    @sidebar_content = @home_page.children.create({:name => "home_sidebar_content", :widget_type => "sidebar_content"})
    @main.each do |widget_id|
      if widget_id =~ /^([0-9]+)$/
      	widget_id = $1
      end
      widget = Widget.find_by_id(widget_id)
      @main_content.children.create({:name => "home_#{widget.name}_widget", :widget => widget, :widget_type => "widget"})
    end
    @sidebar.each do |widget_id|
      widget_position = nil
      if widget_id =~ /^([0-9]+)(?:-(left|right|))?$/
      	widget_id = $1
      	widget_position = $2
      end
      widget = Widget.find_by_id(widget_id)
      @sidebar_content.children.create({:name => "home_#{widget.name}_widget", :widget => widget, :widget_type => "widget", :position => widget_position})
    end

    WidgetSweeper.expire_all
    render :json => {:success => "Success!"}.to_json and return
  end

  private

  def set_current_tab
    @current_tab = 'widgets';
  end

end
