class IdeaBoardsController < ApplicationController
  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :login_required, :only => [:new, :create, :update]
  before_filter :load_top_ideas, :only => :index
  before_filter :load_newest_ideas, :only => :index

  def index
    @current_sub_tab = 'Browse Idea Topics'
    @idea_boards = IdeaBoard.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
  end

  def show
    @current_sub_tab = 'Browse Board Ideas'
    @paginate = true
    @idea_board = IdeaBoard.active.find(params[:id])
    @ideas = @idea_board.ideas.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
    set_sponsor_zone('ideas', @idea_board.item_title.underscore)
  end

  private

  def set_current_tab
    @current_tab = 'ideas'
  end

end
