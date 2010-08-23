class Admin::NewswiresController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Newswire.newest.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Newswire,
    	:fields => [:title, :feed_id, :created_at],
    	:associations => { :belongs_to => { :feed => :feed_id } },
    	:paginate => true
    }
  end

  def new
    @newswire = Newswire.new
  end

  def edit
    @newswire = Newswire.find(params[:id])
  end

  def update
    @newswire = Newswire.find(params[:id])
    if @newswire.update_attributes(params[:newswire])
      flash[:success] = "Successfully updated your Newswire."
      redirect_to [:admin, @newswire]
    else
      flash[:error] = "Could not update your Newswire as requested. Please try again."
      render :edit
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Newswire.find(params[:id]),
    	:model => Newswire,
    	:fields => [:title, :feed_id, :caption, :created_at],
    	:associations => { :belongs_to => { :feed => :feed_id } }
    }
  end

  def create
    @newswire = Newswire.new(params[:newswire])
    @newswire.user = current_user
    if @newswire.save
      flash[:success] = "Successfully created your new Newswire!"
      redirect_to [:admin, @newswire]
    else
      flash[:error] = "Could not create your Newswire, please try again"
      render :new
    end
  end

  def destroy
    @newswire = Newswire.find(params[:id])
    @newswire.destroy

    redirect_to admin_newswires_path
  end

  private

  def set_current_tab
    @current_tab = 'newswires';
  end

end
