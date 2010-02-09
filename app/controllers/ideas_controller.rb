class IdeasController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:new, :create, :update]
  before_filter :load_top_ideas
  before_filter :load_newest_ideas
  before_filter :set_idea_board

  def index
    @current_sub_tab = 'Browse Ideas'
    @ideas = Idea.newest
  end

  def new
    @current_sub_tab = 'Suggest Idea'
    @idea = Idea.new
    @idea.idea_board = @idea_board if @idea_board.present?
    @ideas = Idea.newest
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    @idea.tag_list = params[:idea][:tags_string]
    if params[:idea][:idea_board_id].present?
    	@idea_board = IdeaBoard.find_by_id(params[:idea][:idea_board_id])
    	@idea.section_list = @idea_board.section unless @idea_board.nil?
    end

    if @idea.save
    	flash[:success] = "Thank you for your idea!"
    	redirect_to @idea_board.present? ? [@idea_board, @idea] : @idea
    else
      @ideas = Idea.newest
    	render :new
    end
  end

  def show
    @idea = Idea.find(params[:id])
    tag_cloud @idea
  end

  # TODO:: fb comments method
#  def commented
#    render :text => "Commented" and return
#  end

  def my_ideas
    @current_sub_tab = 'My Ideas'
    @user = User.find(params[:id])
    @ideas = @user.ideas
  end

  def like
    @idea = Idea.find_by_id(params[:id])
    respond_to do |format|
      if current_user and @idea.present? and current_user.vote_for(@idea)
      	success = "Thanks for your vote!"
      	format.html { flash[:success] = success; redirect_to params[:return_to] || ideas_path }
      	format.fbml { flash[:success] = success; redirect_to params[:return_to] || ideas_path }
      	format.json { render :json => { :msg => "#{@idea.votes.size} likes" }.to_json }
      	format.fbjs { render :json => { :msg => "#{@idea.votes.size} likes" }.to_json }
      else
      	error = "Vote failed"
      	format.html { flash[:error] = error; redirect_to params[:return_to] || ideas_path }
      	format.fbml { flash[:error] = error; redirect_to params[:return_to] || ideas_path }
      	format.json { render :json => { :msg => error }.to_json }
      	format.fbjs { render :text => { :msg => error }.to_json }
      end
    end
  end

  private

  def set_idea_board
    @idea_board = params[:idea_board_id].present? ? IdeaBoard.find(params[:idea_board_id]) : nil
  end

  def set_current_tab
    @current_tab = 'ideas'
  end

end
