class Admin::IdeasController < AdminController
  skip_before_filter :admin_user_required
  
  def index
    @ideas = Idea.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @idea = Idea.new
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])
    if @idea.update_attributes(params[:idea])
      flash[:success] = "Successfully updated your Idea ."
      redirect_to [:admin, @idea]
    else
      flash[:error] = "Could not update your Idea  as requested. Please try again."
      render :edit
    end
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    if @idea.save
      flash[:success] = "Successfully created your new Idea !"
      redirect_to [:admin, @idea]
    else
      flash[:error] = "Could not create your Idea , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'ideas';
  end

end
