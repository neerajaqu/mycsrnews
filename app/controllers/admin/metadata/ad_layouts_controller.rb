class Admin::Metadata::AdLayoutsController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::AdLayout.paginate(:page => params[:page], :per_page => 25, :order => "created_at desc"),
    	:model => Metadata::AdLayout,
    	:fields => [:ad_layout_name, :ad_layout_layout],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @ad_layout = Metadata::AdLayout.find(params[:id])

    render_edit @ad_layout
  end

  def update
    @ad_layout = Metadata::AdLayout.find(params[:id])
    if @ad_layout.update_attributes(params[:metadata_ad_layout])
      flash[:success] = "Successfully updated your ad layout."
      redirect_to admin_metadata_ad_layout_path(@ad_layout)
    else
      flash[:error] = "Could not update your ad layout as requested. Please try again."
      render_edit @ad_layout
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::AdLayout.find(params[:id]),
      :model => Metadata::AdLayout,
    	:fields => [:ad_layout_name, :ad_layout_layout, :created_at],
    }
  end

  def create
    @ad_layout = Metadata::AdLayout.new(params[:metadata_ad_layout])
    if @ad_layout.save
      flash[:success] = "Successfully created your ad layout."
      redirect_to admin_metadata_ad_layout_path(@ad_layout)
    else
      flash[:error] = "Could not create your ad layout as requested. Please try again."
      render_new @ad_layout
    end
  end

  def destroy
    @ad_layout = Metadata::AdLayout.find(params[:id])
    @ad_layout.destroy

    redirect_to admin_metadata_ad_layouts_path
  end

  private

  def render_new ad_layout = nil
    ad_layout ||= Metadata::AdLayout.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => ad_layout,
    	:model => Metadata::AdLayout,
    	:fields => [:ad_layout_name, :ad_layout_layout]
    }
  end

  def render_edit ad_layout
    ad_layout ||= Metadata::AdLayout.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => ad_layout,
    	:model => Metadata::AdLayout,
    	:fields => [:ad_layout_name, :ad_layout_layout]
    }
  end

  def set_current_tab
    @current_tab = 'ad_layouts';
  end

end
