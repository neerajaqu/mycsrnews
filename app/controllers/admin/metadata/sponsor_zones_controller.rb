class Admin::Metadata::SponsorZonesController < Admin::MetadataController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Metadata::SponsorZone.paginate(:page => params[:page], :per_page => 30, :order => "key_sub_type asc"),
    	:model => Metadata::SponsorZone,
    	:fields => [:sponsor_zone_name, :sponsor_zone_topic, :sponsor_zone_code],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @sponsor_zone = Metadata::SponsorZone.find(params[:id])

    render_edit @sponsor_zone
  end

  def update
    @sponsor_zone = Metadata::SponsorZone.find(params[:id])
    if @sponsor_zone.update_attributes(params[:metadata_sponsor_zone])
      flash[:success] = "Successfully updated your sponsor_zone."
      redirect_to admin_metadata_sponsor_zone_path(@sponsor_zone)
    else
      flash[:error] = "Could not update your sponsor_zone as requested. Please try again."
      render_edit @sponsor_zone
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Metadata::SponsorZone.find(params[:id]),
      :model => Metadata::SponsorZone,
    	:fields => [:sponsor_zone_name, :sponsor_zone_topic, :sponsor_zone_code]
    }
  end

  def create
    @sponsor_zone = Metadata::SponsorZone.new(params[:metadata_sponsor_zone])
    if @sponsor_zone.save
      flash[:success] = "Successfully created your sponsor_zone."
      redirect_to admin_metadata_sponsor_zone_path(@sponsor_zone)
    else
      flash[:error] = "Could not create your sponsor_zone as requested. Please try again."
      render_new @sponsor_zone
    end
  end

  def destroy
    @sponsor_zone = Metadata::SponsorZone.find(params[:id])
    @sponsor_zone.destroy

    redirect_to admin_metadata_sponsor_zones_path
  end

  private

  def render_new sponsor_zone = nil
    sponsor_zone ||= Metadata::SponsorZone.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => sponsor_zone,
    	:model => Metadata::SponsorZone,
    	:fields => [:sponsor_zone_name, :sponsor_zone_topic, :sponsor_zone_code]
    }
  end

  def render_edit sponsor_zone
    sponsor_zone ||= Metadata::SponsorZone.new
=begin
    if sponsor_zone.name == 'site_notification_user'
      render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      	:item => sponsor_zone,
      	:model => Metadata::SponsorZone,
    	:fields => [:sponsor_zone_name, :sponsor_zone_topic, :sponsor_zone_code]
      }
    else  
    end
=end
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => sponsor_zone,
    	:model => Metadata::SponsorZone,
    	:fields => [:sponsor_zone_name, :sponsor_zone_topic, :sponsor_zone_code]
    }
  end

  def set_current_tab
    @current_tab = 'sponsor_zones';
  end

end
