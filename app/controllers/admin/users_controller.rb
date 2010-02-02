class Admin::UsersController < AdminController
  skip_before_filter :admin_user_required

  def index
    @users = User.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Successfully updated your User."
      redirect_to [:admin, @user]
    else
      flash[:error] = "Could not update your User as requested. Please try again."
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Successfully created your new User!"
      redirect_to [:admin, @user]
    else
      flash[:error] = "Could not create your User, please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'users';
  end

end
