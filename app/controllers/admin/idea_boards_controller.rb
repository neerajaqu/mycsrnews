class Admin::IdeaBoardsController < AdminController
  skip_before_filter :admin_user_required

  def index
    @idea_boards = IdeaBoard.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def new
    @idea_board = IdeaBoard.new
  end

  def edit
    @idea_board = IdeaBoard.find(params[:id])
  end

  def update
    @idea_board = IdeaBoard.find(params[:id])
    if @idea_board.update_attributes(params[:idea_board])
      flash[:success] = "Successfully updated your Idea Topic."
      redirect_to [:admin, @idea_board]
    else
      flash[:error] = "Could not update your Idea Topic as requested. Please try again."
      render :edit
    end
  end

  def show
    @idea_board = IdeaBoard.find(params[:id])
  end

  def create
    @idea_board = IdeaBoard.new(params[:idea_board])
    if @idea_board.save
      flash[:success] = "Successfully created your new Idea Topic!"
      redirect_to [:admin, @idea_board]
    else
      flash[:error] = "Could not create your Idea Topic, please try again"
      render :new
    end
  end

  def destroy
    @idea_board = IdeaBoard.find(params[:id])
    @idea_board.destroy
    redirect_to admin_idea_boards_path
  end

  private

  def set_current_tab
    @current_tab = 'idea-boards';
  end

end
