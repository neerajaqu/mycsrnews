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
      { :name => 'media', :regex => /image|video/i },
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
