class ArticlesController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :drafts, :create, :edit, :update, :like], :if => :request_comes_from_facebook?
  before_filter :check_valid_user, :only => [:edit, :update ]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy, :like]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :drafts, :user_index]
  before_filter :login_required, :only => [:new, :create]
  before_filter :load_top_stories, :only => [:index]
  before_filter :load_top_discussed_stories, :only => [:index]
  before_filter :load_newest_articles, :only => [:index]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Articles'
    @articles = Content.articles.active.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    set_sponsor_zone('articles')
    respond_to do |format|
      format.html { @paginate = true }
      format.json { @articles = Content.articles.active.refine(params) }
    end
  end

  def drafts
    @current_sub_tab = 'Draft Articles'
    @drafts = current_user.contents.draft_articles
  end

  def user_index
    @user = User.find(params[:user_id])    
    @page = false
    @current_sub_tab = 'Browse Articles'
    @articles = @user.articles.active.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    respond_to do |format|
      format.html { @refine = false, @paginate = false }
      #format.json { @articles = Content.articles.refine(params) }
    end
  end

  def edit
    @current_sub_tab = 'New Article'
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    @article.content.caption = @article.body = params[:article][:body]
    @article.create_preamble
    @article.tag_list = params[:article][:content_attributes][:tags_string]
    @article.post_wall = params[:article][:content_attributes][:post_wall]
    @article.is_draft = params[:is_draft]
    @article.content.user = @article.author
    @article.author = @article.author
    if @article.valid? and @article.update_attributes(params[:article]) and @article.update_attribute(:is_draft, params[:is_draft])
      unless @article.is_draft
        if @article.post_wall?
          session[:post_wall] = @article.content
        end            
        flash[:success] = "Successfully posted your article!"
        redirect_to story_path(@article.content)
      else
        flash[:success] = "Successfully saved your draft article!"
        redirect_to drafts_articles_path()
      end
    else
    	flash[:error] = "Could not create your article. Please fix the errors and try again."
    	render :new
    end
  end
    
  def new
    if get_setting('limit_daily_member_posts').present? and get_setting('limit_daily_member_posts').value.to_i <= current_user.count_daily_posts
      flash[:error] = t('error_daily_post_limit')
      redirect_to home_index_path
    end
    @current_sub_tab = 'New Article'
    @article = Article.new
    @article.build_content
  end

  def create
    @article = Article.new(params[:article])
    @article.content = Content.new(params[:article][:content_attributes].merge(:article => @article))
    @article.content.caption = @article.body
    @article.create_preamble
    @article.tag_list = params[:article][:content_attributes][:tags_string]
    @article.post_wall = params[:article][:content_attributes][:post_wall]
    @article.is_draft = params[:is_draft]
    @article.content.user = current_user
    @article.author = current_user
    unless @article.is_draft
      if @article.valid? and current_user.articles.push @article
        if @article.post_wall?
          session[:post_wall] = @article.content
        end            
        flash[:success] = "Successfully posted your article!"
        redirect_to story_path(@article.content)
      else
      	flash[:error] = "Could not create your article. Please fix the errors and try again."
      	render :new
      end
    else
      if @article.valid? and @article.save
        flash[:success] = "Successfully saved your draft article!"
        redirect_to drafts_articles_path()
      else
      	flash[:error] = "Could not create your article. Please fix the errors and try again."
      	render :new
      end
    end
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @articles = Article.tagged_with(tag_name, :on => 'tags').active.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    render :template => 'articles/index'
  end

  private
  
  def check_valid_user
    redirect_to home_index_path and return false unless current_user and ((current_user == Article.find(params[:id]).author or current_user.is_moderator?))
  end

  def set_current_tab
    if MENU.key? 'articles'
      @current_tab = 'articles'
    else
      @current_tab = 'stories'
    end
  end

end
