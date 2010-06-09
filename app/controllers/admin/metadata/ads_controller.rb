class Admin::Metadata::AdsController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::Ad.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Metadata::Ad,
    	:fields => [:key_name, :key_sub_type, :width, :height, :background, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @ad = Metadata::Ad.find(params[:id])

    render_edit @ad
  end

  def update
    @ad = Metadata::Ad.find(params[:id])
    #@ad.data = params[:custom_data].symbolize_keys
    if @ad.update_attributes(params[:metadata_ad])
      flash[:success] = "Successfully updated your ad."
      redirect_to admin_metadata_ad_path(@ad)
    else
      flash[:error] = "Could not update your ad as requested. Please try again."
      render_edit @ad
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::Ad.find(params[:id]),
      :model => Metadata::Ad,
    	:fields => [:key_name, :key_sub_type, :width, :height, :background, :created_at],
    }
  end

  def create
    @ad = Metadata::Ad.new(params[:metadata_ad])
    if @ad.save
      flash[:success] = "Successfully created your ad."
      redirect_to admin_metadata_ad_path(@ad)
    else
      flash[:error] = "Could not create your ad as requested. Please try again."
      render_new @ad
    end
  end

  def destroy
    @ad = Metadata::Ad.find(params[:id])
    @ad.destroy

    redirect_to admin_metadata_ads_path
  end

  private

  def render_new ad = nil
    ad ||= Metadata::Ad.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => ad,
    	:model => Metadata::Ad,
    	:fields => [:name, :background, :height, :width]
    }
  end

  def render_edit ad
    ad ||= Metadata::Ad.new

    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => ad,
    	:model => Metadata::Ad,
    	:fields => [:name, :background, :height, :width]
    }
  end

  def set_current_tab
    @current_tab = 'settings';
  end

end
