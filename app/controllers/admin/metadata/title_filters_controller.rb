class Admin::Metadata::TitleFiltersController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::TitleFilter.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata::TitleFilter,
    	:fields => [:keyword],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @title_filter = Metadata::TitleFilter.find(params[:id])

    render_edit @title_filter
  end

  def update
    @title_filter = Metadata::TitleFilter.find(params[:id])
    if @title_filter.update_attributes(params[:metadata_title_filter])
      flash[:success] = "Successfully updated your title filter."
      redirect_to admin_metadata_title_filter_path(@title_filter)
    else
      flash[:error] = "Could not update your title filter as requested. Please try again."
      render_edit @title_filter
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::TitleFilter.find(params[:id]),
      :model => Metadata::TitleFilter,
    	:fields => [:title_filter_name, :title_filter_sub_type_name, :title_filter_value, :created_at],
    }
  end

  def create
    @title_filter = Metadata::TitleFilter.new(params[:metadata_title_filter])
    if @title_filter.save
      flash[:success] = "Successfully created your title filter."
      redirect_to admin_metadata_title_filter_path(@title_filter)
    else
      flash[:error] = "Could not create your title filter as requested. Please try again."
      render_new @title_filter
    end
  end

  def destroy
    @title_filter = Metadata::TitleFilter.find(params[:id])
    @title_filter.destroy

    redirect_to admin_metadata_title_filters_path
  end

  private

  def render_new title_filter = nil
    title_filter ||= Metadata::TitleFilter.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => title_filter,
    	:model => Metadata::TitleFilter,
    	:fields => [:keyword]
    }
  end

  def render_edit title_filter
    title_filter ||= Metadata::TitleFilter.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => title_filter,
    	:model => Metadata::TitleFilter,
    	:fields => [:keyword]
    }
  end

  def set_current_tab
    @current_tab = 'title_filters';
  end

end
