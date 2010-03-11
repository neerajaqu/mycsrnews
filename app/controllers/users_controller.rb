class UsersController < ApplicationController
  cache_sweeper :profile_sweeper, :only => [:update_bio]
  cache_sweeper :user_sweeper, :only => [:create, :link_user_accounts]

  before_filter :login_required, :only => [:update_bio]
  before_filter :load_top_stories, :only => [:show]
  before_filter :ensure_authenticated_to_facebook, :only => :link_user_accounts

  def new
    @user = User.new
  end
 
  def create
    unless params[:user].present?
      @user = User.new
      render :new
      return false
    end
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      set_facebook_session unless facebook_session.present?
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    redirect_to root_path
  end

  def show
    @user = User.find(params[:id])
    @is_owner = current_user && (@user.id == current_user.id)
    @curr_action = params[:curr_action] || 'stories'
    if @curr_action == 'stories'
    	@actions = @user.contents.newest_stories
    elsif @curr_action == 'articles'
    	@actions = @user.contents.newest_articles
    elsif @curr_action == 'comments'
    	@actions = @user.comments.newest
    elsif @curr_action == 'likes'
    	@actions = @user.votes.newest
    else
      @actions = false
    end
    respond_to do |format|
      format.html
      format.fbml
      format.atom { @actions = @user.newest_actions }
    end
  end

  def invite
    @success = false
    if request.post?
    	if params['action'] == 'invite' and params['ids'].present?
    		flash[:notice] = "Successfully invited your friends."
    		@fb_user_ids = params['ids']
    		@success = true
    	end
    end
  end

  def update_bio    
    if request.post?
      @profile = current_user_profile
      @profile.bio = params['bio']
      if @profile.save
    		flash[:success] = "Successfully edited your bio."
    		redirect_to user_path(@profile.user)    	
      else
    		flash[:error] = "Could not update your bio."
    		redirect_to user_path(@profile.user)    	
    	end
    end
  end
  
  def account_menu
    respond_to do |format|
      format.fbjs
      format.js
    end     
  end
  
  def current
    respond_to do |format|
      format.fbjs
      format.js
      format.fbml { render :template => 'users/current.js', :content_type => 'text/javascript', :layout => false }
    end
  end

end
