class ClassifiedsController < ApplicationController

  before_filter :set_current_tab

  def index
    @current_sub_tab = 'Browse'
    # to do - implement recently viewed scope or method for current user 
    @recently_viewed_classifieds = Classified.newest 5
  end

  def new
    @current_sub_tab = 'New Item'
    @classified = Classified.new
    # @classified.classified_board = @classified_board if @classified_board.present?
    #@classifieds = Classified.active.newest
  end

  def create
    @classified = Classified.new(params[:classified])
    #@classified.tag_list = params[:classified][:tags_string]
    @classified.user = current_user
    #if params[:classified][:classified_board_id].present?
    #	@classified_board = ClassifiedBoard.active.find_by_id(params[:classified][:classified_board_id])
    #	@classified.section_list = @classified_board.section unless @classified_board.nil?
    #end

    if @classified.valid? and current_user.classifieds.push @classified
      if @classified.post_wall?
        session[:post_wall] = @classified
      end      
      if get_setting('tweet_all_moderator_items').try(:value)
        if current_user.present? and current_user.is_moderator?
          @classified.tweet
        end
      end
    	flash[:success] = "Thank you for posting your item!"
    	redirect_to @classified_board.present? ? [@classified_board, @classified] : @classified
    else
      @classifieds = Classified.active.newest
    	render :new
    end
  end

  def show
    @classified = Classified.active.find(params[:id])    
    @current_sub_tab = 'Show'
  end

  def edit
    @current_sub_tab = 'Edit'
  end

  def my_items
    @current_sub_tab = 'My Items'
  end

  def borrowed_items
    @current_sub_tab = 'My Borrowed Items'
  end

  def set_current_tab
    @current_tab = 'classifieds'
  end

end
