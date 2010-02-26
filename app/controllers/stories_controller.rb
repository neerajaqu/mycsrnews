class StoriesController < ApplicationController
  caches_page :show, :index
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy, :like]

  before_filter :set_current_tab
  before_filter :login_required, :only => [:like, :new, :create]
  before_filter :load_top_stories, :only => [:index, :tags]
  before_filter :load_top_discussed_stories, :only => [:index, :tags]
  before_filter :load_top_users, :only => [:index, :app_tab, :tags]
  before_filter :load_newest_users, :only => [:index, :app_tab, :tags]

  def index
    @contents = Content.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    respond_to do |format|
      format.html
      format.fbml
      format.atom
      format.json { @stories = Content.refine(params) }
      format.fbjs { @stories = Content.refine(params) }
    end
  end

  def show
    @story = Content.find(params[:id])
    tag_cloud @story
  end

  def new
    @story = Content.new
  end

  def create
    @story = Content.new(params[:content])
    @story.user = current_user
    @story.tag_list = params[:content][:tags_string]
    @story.caption = @template.sanitize_user_content @story.caption
    if params[:content][:image_url].present?
      @story.build_content_image({:url => params[:content][:image_url]})
    end
    if @story.save
      flash[:success] = "Successfully posted your story!"
      redirect_to story_path(@story)
    else
    	flash[:error] = "Could not create your story. Please clear the errors and try again."
    	render :new
    end
  end

  def like
    @story = Content.find_by_id(params[:id])
    respond_to do |format|
      if current_user and @story.present? and current_user.vote_for(@story)
      	success = "Thanks for your vote!"
      	format.html { flash[:success] = success; redirect_to params[:return_to] || stories_path }
      	format.fbml { flash[:success] = success; redirect_to params[:return_to] || stories_path }
      	format.json { render :json => { :msg => "#{@story.votes.size} likes" }.to_json }
      	format.fbjs { render :json => { :msg => "#{@story.votes.size} likes" }.to_json }
      else
      	error = "Vote failed"
      	format.html { flash[:error] = error; redirect_to params[:return_to] || stories_path }
      	format.fbml { flash[:error] = error; redirect_to params[:return_to] || stories_path }
      	format.json { render :json => { :msg => error }.to_json }
      	format.fbjs { render :text => { :msg => error }.to_json }
      end
    end
  end

  def parse_page
    @url = params[:url]
    @page_data = Parse::Page.parse_page(@url) unless @url.empty?
    respond_to do |format|
      format.html { render :text => @page_data }
      format.json { render :json => @page_data.to_json }
    end
  end

  def tags
    @paginate = true
    @contents = Content.tagged_with(params[:tag], :on => 'tags').paginate :page => params[:page], :per_page => 20, :order => "created_at desc"

  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

end
