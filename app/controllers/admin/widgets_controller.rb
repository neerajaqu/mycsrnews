class Admin::WidgetsController < AdminController
  skip_before_filter :admin_user_required

  def index
    @main = Widget.main
    @sidebar = Widget.sidebar
  end

  def save
    # TODO:: Switch to updating instead of deleting
    WidgetPage.all.each {|w| w.destroy}
    @main = params[:main].split /,/
    @sidebar = params[:sidebar].split /,/

    @home_page = WidgetPage.create({:name => 'home'})
    @main_content = @home_page.children.create({:name => "home_main_content", :widget_type => "main_content"})
    @sidebar_content = @home_page.children.create({:name => "home_sidebar_content", :widget_type => "sidebar_content"})
    @main.each do |widget_id|
      widget = Widget.find_by_id(widget_id)
      @main_content.children.create({:name => "home_#{widget.name}_widget", :widget => widget, :widget_type => "widget"})
    end
    @sidebar.each do |widget_id|
      widget = Widget.find_by_id(widget_id)
      @sidebar_content.children.create({:name => "home_#{widget.name}_widget", :widget => widget, :widget_type => "widget"})
    end

    render :json => {:success => "Success!"}.to_json and return
  end

  private

  def set_current_tab
    @current_tab = 'widgets';
  end

end
