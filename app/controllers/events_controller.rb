class EventsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?
  before_filter :set_current_tab
  before_filter :login_required, :only => [:like, :new, :create, :update]
  before_filter :load_top_events
  before_filter :load_newest_events
  before_filter :load_featured_events, :only => [:index]

  def index
    @current_sub_tab = 'Browse Events'
    @events = Event.paginate :page => params[:page], :per_page => Event.per_page, :order => "created_at desc"
   respond_to do |format|
      format.html
      format.fbml
      format.atom
      format.json { @events = Event.refine(params) }
      format.fbjs { @events = Event.refine(params) }
    end
  end

  def new
    @current_sub_tab = 'Suggest Event'
    @event = Event.new
    @events = Event.active.newest
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    @event.tag_list = params[:event][:tags_string]

    if @event.save
    	flash[:success] = "Thank you for your event!"
      @events = Event.active.newest
    	render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    tag_cloud @event
  end

  def my_events
    @current_sub_tab = 'My Events'
    @user = User.find(params[:id])
    @events = @user.events
  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'events')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'events')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'events')
  end

  private

  def set_current_tab
    @current_tab = 'events'
  end

end
