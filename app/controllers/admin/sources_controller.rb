class Admin::SourcesController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Source.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Source,
    	:fields => [:name, :url, :all_subdomains_valid, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @source = Source.find(params[:id])

    render_edit @source
  end

  def update
    @source = Source.find(params[:id])
    params[:source][:url] = params[:source][:url].sub(/^\/+/,'').sub(/^http:\/\/(www.)*/,'').strip.sub(/\/+$/,'')
    if @source.update_attributes(params[:source])
      flash[:success] = "Successfully updated your Source."
      redirect_to [:admin, @source]
    else
      flash[:error] = "Could not update your Source as requested. Please try again."
      render_edit @source
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Source.find(params[:id]),
    	:model => Source,
    	:fields => [:name, :url, :all_subdomains_valid, :created_at],
    }
  end

  def create
    @source = Source.new(params[:source])
    @source.url = params[:source][:url].sub(/^\/+/,'').sub(/^http:\/\/(www.)*/,'').strip.sub(/\/+$/,'')
    if @source.save
      flash[:success] = "Successfully created your new Source!"
      redirect_to [:admin, @source]
    else
      flash[:error] = "Could not create your Source, please try again"
      render_new @source
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    redirect_to admin_sources_path
  end

  private

  def render_new source = nil
    source ||= Source.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @source,
    	:model => Source,
    	:fields => [:name, :url, :all_subdomains_valid],
    }
  end

  def render_edit source
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => source,
    	:model => Source,
    	:fields => [:name, :url, :all_subdomains_valid ]
    }
  end

  def set_current_tab
    @current_tab = 'sources';
  end

end
