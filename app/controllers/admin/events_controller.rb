class Admin::EventsController < AdminController

  def index
    @events = Event.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "Successfully updated your Event ."
      redirect_to [:admin, @event]
    else
      flash[:error] = "Could not update your Event  as requested. Please try again."
      render :edit
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    if @event.save
      flash[:success] = "Successfully created your new Event !"
      redirect_to [:admin, @event]
    else
      flash[:error] = "Could not create your Event , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'events';
  end

end