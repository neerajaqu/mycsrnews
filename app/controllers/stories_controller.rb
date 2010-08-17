class StoriesController < ApplicationController
  #caches_page :show, :index
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:wizard, :new, :create, :update, :like], :if => :request_comes_from_facebook?

  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy, :like]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :login_required, :only => [:wizard, :like, :new, :create]
  before_filter :load_top_stories, :only => [:index, :tags]
  before_filter :load_top_discussed_stories, :only => [:index, :tags]
  before_filter :load_top_users, :only => [:index, :app_tab, :tags]
  before_filter :load_newest_users, :only => [:index, :app_tab, :tags]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Stories'
    if get_setting('exclude_articles_from_news').value
      @contents = Content.top_story_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    else
      @contents = Content.top_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    end
    #@contents = Content.active.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
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
    # allow only authors and moderators to preview draft articles
    redirect_to home_index_path if @story.is_article? and @story.article.is_draft? and (!current_user.present? or current_user != @story.article.author or !current_user.is_moderator? ) 
    tag_cloud (@story.is_article? ? @story.article : @story)
    if MENU.key? 'articles'
      @current_tab = 'articles' if @story.is_article?
    end

    set_outbrain_item @story
  end

  def wizard
    new
  end
  
  def new 
   if current_user.present? and !current_user.is_moderator? and get_setting('limit_daily_member_posts').present? and get_setting('limit_daily_member_posts').value.to_i <= current_user.count_daily_posts
      flash[:error] = t('error_daily_post_limit')
      redirect_to home_index_path
   end
   @current_sub_tab = 'New Story'
   @title_filters = Metadata::TitleFilter.all.map(&:keyword)
   if params[:u].present?
      title = params[:t]
      title = @title_filters.inject(title) {|str,key| str.gsub(%r{#{key}}, '') }
      title.sub(/^[|\s]+/,'').sub(/[|\s]+$/,'')
      @story = Content.new({
      	:url      => params[:u],
      	:title    => title,
      	:caption  => params[:c]
      })
    elsif params[:newswire_id].present?
      @newswire = Newswire.find(params[:newswire_id])
      title = @newswire.title
      title = @title_filters.inject(title) {|str,key| str.gsub(%r{#{key}}, '') }
      title.sub(/^[|\s]+/,'').sub(/[|\s]+$/,'')
      @story = Content.new({
      	:url      => @newswire.url,
      	:title    => title,
      	:caption  => @template.strip_tags(@newswire.caption),
      	:newswire => @newswire
      })
    else
      @story = Content.new
    end
  end

  def create
    @story = Content.new(params[:content])
    @story.tag_list = params[:content][:tags_string]
    @story.caption = @template.sanitize_user_content @story.caption
    @story.user = current_user
    if @story.valid? and current_user.contents.push @story
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

  private
  
  def set_current_tab
    @current_tab = 'stories'
  end

end
