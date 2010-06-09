class Admin::Metadata::CustomWidgetsController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::CustomWidget.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata::CustomWidget,
    	:fields => [:title, :content_type, :key_sub_type, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @custom_widget = Metadata::CustomWidget.find(params[:id])

    render_edit @custom_widget
  end

  def update
    @custom_widget = Metadata::CustomWidget.find(params[:id])
    if @custom_widget.update_attributes(params[:metadata_custom_widget])
      flash[:success] = "Successfully updated your custom widget."
      redirect_to admin_metadata_custom_widget_path(@custom_widget)
    else
      flash[:error] = "Could not update your custom_widget as requested. Please try again."
      render_edit @custom_widget
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::CustomWidget.find(params[:id]),
      :model => Metadata::CustomWidget,
    	:fields => [:title, :key_name, :content_type, :key_sub_type, :created_at, :custom_data]
    }
  end

  def create
    @custom_widget = Metadata::CustomWidget.new(params[:metadata_custom_widget])
    if @custom_widget.save
      flash[:success] = "Successfully created your custom widget."
      redirect_to admin_metadata_custom_widget_path(@custom_widget)
    else
      flash[:error] = "Could not create your custom_widget as requested. Please try again."
      render_new @custom_widget
    end
  end

  def destroy
    @custom_widget = Metadata::CustomWidget.find(params[:id])
    @custom_widget.destroy

    redirect_to admin_metadata_custom_widgets_path
  end

  private

  def render_new custom_widget = nil
    custom_widget ||= Metadata::CustomWidget.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => custom_widget,
    	:model => Metadata::CustomWidget,
    	:fields => [
    	  :title,
    	  lambda {|f| f.input :custom_data, :as => :text, :input_html => { :rows => 30, :cols => 80} },
    	  lambda {|f| f.input :content_type, :as => :select, :collection => [['Main Content', 'main_content'], ['Sidebar Content', 'sidebar_content']]}
      ]
    }
  end

  def render_edit custom_widget
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => custom_widget,
    	:model => Metadata::CustomWidget,
    	:fields => [
    	  :title,
    	  lambda {|f| f.input :custom_data, :as => :text, :input_html => { :rows => 30, :cols => 80} },
    	  lambda {|f| f.input :content_type, :as => :select, :collection => [['Main Content', 'main_content'], ['Sidebar Content', 'sidebar_content']]}
      ]
    }
  end

  def set_current_tab
    @current_tab = 'settings';
  end

end
