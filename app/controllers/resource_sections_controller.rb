class ResourceSectionsController < ApplicationController
  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :login_required, :only => [:new, :create, :update]
  before_filter :load_top_resources, :only => :index
  before_filter :load_newest_resources, :only => :index
  before_filter :load_newest_resource_sections

  def index
    @current_sub_tab = 'Browse Resource Sections'
    @resource_sections = ResourceSection.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
  end

  def show
    @current_sub_tab = 'Browse Section Resources'
    @resource_section = ResourceSection.find(params[:id])
    @top_resources = @resource_section.resources.tally({
    	:at_least => 1,
    	:limit    => 5,
    	:order    => "votes.count desc"
    })
    @newest_resources = @resource_section.resources.newest 5
    set_sponsor_zone('resources', @resource_section.item_title.underscore)    
  end

  private

  def set_current_tab
    @current_tab = 'resources'
  end

end
