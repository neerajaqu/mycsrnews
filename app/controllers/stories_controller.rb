class StoriesController < ApplicationController
  #caches_page :show, :index
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?

  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy, :like]

  before_filter :set_current_tab
  before_filter :login_required, :only => [:like, :new, :create]
  before_filter :load_top_stories, :only => [:index, :tags]
  before_filter :load_top_discussed_stories, :only => [:index, :tags]
  before_filter :load_top_users, :only => [:index, :app_tab, :tags]
  before_filter :load_newest_users, :only => [:index, :app_tab, :tags]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Stories'
    #@contents = Content.active.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    @contents = Content.top_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    respond_to do |format|
      format.html { @paginate = true }
      format.fbml { @paginate = true }
      format.atom
      format.json { @stories = Content.refine(params) }
      format.fbjs { @stories = Content.refine(params) }
    end
  end

  def show
    @story = Content.find(params[:id])
    tag_cloud (@story.is_article? ? @story.article : @story)
    if MENU.key? 'articles'
      @current_tab = 'articles' if @story.is_article?
    end
  end

  def new
   @current_sub_tab = 'New Story'
   if params[:u].present?
      @story = Content.new({
      	:url      => params[:u],
      	:title    => params[:t],
      	:caption  => params[:c]
      })
    elsif params[:newswire_id].present?
      @newswire = Newswire.find(params[:newswire_id])
      @story = Content.new({
      	:url      => @newswire.url,
      	:title    => @newswire.title,
      	:caption  => @template.strip_tags(@newswire.caption),
      	:newswire => @newswire
      })
    else
      @story = Content.new
    end
  end

  def create
    @story = Content.new(params[:content])
    @story.user = current_user
    @story.tag_list = params[:content][:tags_string]
    @story.caption = @template.sanitize_user_content @story.caption
    if @story.save
      if @story.post_wall?
        session[:post_wall] = @story
      end
      flash[:success] = "Successfully posted your story!"
      redirect_to story_path(@story)
    else
    	flash[:error] = "Could not create your story. Please clear the errors and try again."
    	render :new
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
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @contents = Content.tagged_with(tag_name, :on => 'tags').active.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'stories')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'stories')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'stories')
    @ad_small_square = Metadata.get_ad_slot('small_square', 'stories')
  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

end
