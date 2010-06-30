class EventsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?

  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy, :import_facebook]

  before_filter :set_current_tab
  before_filter :login_required, :only => [:like, :new, :create, :update]
  before_filter :load_top_events
  before_filter :load_newest_events
  before_filter :load_featured_events, :only => [:index]
  before_filter :set_custom_sidebar_widget, :only => [:index, :new, :show, :my_events, :import_facebook]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Events'
    @events = Event.active.paginate :page => params[:page], :per_page => Event.per_page, :order => "created_at desc"
   respond_to do |format|
      format.html { @paginate = true }
      format.fbml { @paginate = true }
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
    @event.tag_list = params[:event][:tags_string]

    if @event.valid? and current_user.events.push @event
      if @event.post_wall?
        session[:post_wall] = @event
      end            
    	flash[:success] = "Thank you for your event!"
    	redirect_to @event
    else
    	flash[:error] = "Could not create your event. Please clear the errors and try again."
    	render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    tag_cloud @event
  end

  def my_events
    @paginate = true
    @current_sub_tab = 'My Events'
    @user = User.find(params[:id])
    @events = @user.events.active.paginate :page => params[:page], :per_page => Event.per_page, :order => "created_at desc"
  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'events')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'events')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'events')
  end

  def import_facebook
    if request.post?
      @events = current_facebook_user.events(:eids=>params[:fb_events].join(','))
      @events.each do |event|
        Event.create_from_facebook_event(event,current_user)
      end
      flash[:succes] = "Your events have successfully been imported."
      redirect_to events_path
    else
      if current_facebook_user
        @event = Event.new
        @fb_events = current_facebook_user.events(:start_time => Time.now, :end_time => 1.month.from_now)
        current_events = Event.find(:all, :conditions=>["eid IN (?)", @fb_events.collect { |e| e.eid }]).collect { |e| e.eid }
        @fb_events.delete_if {|x| current_events.include? x.eid.to_s }
      else
        flash[:info] = "You need to connect via Facebook."
        redirect_to events_path
      end
    end
  end
  
  private

  def set_current_tab
    @current_tab = 'events'
  end

end
