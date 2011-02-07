class ClassifiedsController < ApplicationController
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  before_filter :find_classified, :only => [:show, :edit, :update]
  
  access_control do
    allow all, :to => [:index]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :borrowed_items, :my_items]
    allow anonymous, :to => [:show], :if => :classified_allows_anonymous_users?
    allow :allowed, :of => :classified, :to => [:show, :edit, :update]
  end

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

  private 

    def set_current_tab
      @current_tab = 'classifieds'
    end

    def access_denied
      if current_user
      	flash[:notice] = "Access Denied"
      	redirect_to classifieds_path
      else
      	flash[:notice] = "Access Denied. Try logging in first."
      	redirect_to new_session_path
      end
    end

    def find_classified
      @classified ||= Classified.find(params[:id])
    end

    def classified_allows_anonymous_users?
      @classified.is_allowed? nil
    end

end
