class EventsController < ApplicationController
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
    @events = Event.newest
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    @event.tag_list = params[:event][:tags_string]

    if @event.save
    	flash[:success] = "Thank you for your event!"
      @events = Event.newest
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

  def like
    @event = Event.find_by_id(params[:id])
    respond_to do |format|
      if current_user and @event.present? and current_user.vote_for(@event)
      	success = "Thanks for your vote!"
      	format.html { flash[:success] = success; redirect_to params[:return_to] || events_path }
      	format.fbml { flash[:success] = success; redirect_to params[:return_to] || events_path }
      	format.json { render :json => { :msg => "#{@event.votes_tally} likes" }.to_json }
      	format.fbjs { render :json => { :msg => "#{@event.votes_tally} likes" }.to_json }
      else
      	error = "Vote failed"
      	format.html { flash[:error] = error; redirect_to params[:return_to] || events_path }
      	format.fbml { flash[:error] = error; redirect_to params[:return_to] || events_path }
      	format.json { render :json => { :msg => error }.to_json }
      	format.fbjs { render :text => { :msg => error }.to_json }
      end
    end
  end

  private

  def set_current_tab
    @current_tab = 'events'
  end

end
