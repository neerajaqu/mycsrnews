class Admin::CustomWidgetsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata.meta_type('custom_widget').paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata,
    	:fields => [:meta_type, :key_name, :created_at],
    	:paginate => true
    }
  end

  def new
    @metadata = Metadata.new
  end

  def edit
    @metadata = Metadata.find(params[:id])
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => @metadata,
    	:model => Metadata,
    	:fields => [:title, :url, :rss]
    }
  end

  def update
    @metadata = Metadata.find(params[:id])
    if @metadata.update_attributes(params[:metadata])
      flash[:success] = "Successfully updated your Custom Widget."
      redirect_to [:admin, @metadata]
    else
      flash[:error] = "Could not update your Custom Widget as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Metadata.find(params[:id]),
    	:model => Metadata,
    	:fields => [:metadatable_type, :metadatable_id, :data, :created_at],
    }
  end

  def create
    @metadata = Metadata.new(params[:metadata])
    unless @metadata.title.present? and @metadata.custom_data.present? and @metadata.content_type.present?
      @metadata.errors.add(:title, "Title must be present") if @metadata.title.empty?
      @metadata.errors.add(:custom_data, "Custom Data must be present") if @metadata.custom_data.empty?
      @metadata.errors.add(:content_type, "Content Type must be present and valid") if (@metadata.content_type.empty? || (@metadata.content_type != 'main_content' and @metadata.content_type != 'sidebar_content'))

      render :new
      return false
    end
    @metadata.data = {
    	:custom_data  => @metadata.custom_data,
    	:title        => @metadata.title,
    	:content_type => @metadata.content_type
    }
    @metadata.meta_type = "custom_widget"
    @metadata.key_name  = @metadata.title.parameterize
    @widget = Widget.new({
    	:name         => @metadata.title.parameterize,
    	:content_type => @metadata.content_type,
    	:partial      => 'shared/custom_widget'
    })
    @widget.metadatas << @metadata
    if @widget.save
      flash[:success] = "Successfully created your new Custom Widget!"
      redirect_to [:admin, @widget.metadatas.first]
    else
      flash[:error] = "Could not create your Custom Widget, please try again"
      render :new
    end
  end

  def destroy
    @metadata = Metadata.find(params[:id])
    @metadata.destroy

    redirect_to admin_custom_widgets_path
  end

  private

  def set_current_tab
    @current_tab = 'widgets';
  end

end
