class ArticlesController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?
  cache_sweeper :story_sweeper, :only => [:create]

  before_filter :set_current_tab
  before_filter :login_required, :only => [:new, :create]
  before_filter :load_top_stories, :only => [:index]
  before_filter :load_top_discussed_stories, :only => [:index]
  before_filter :load_newest_articles, :only => [:index]

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Articles'
    @articles = Content.articles.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    #@article_images = Image.find(:all, :conditions => ["imageable_type = ?", "Article"], :order => "created_at desc")  
    respond_to do |format|
      format.html { @paginate = true }
      format.json { @articles = Content.refine(params) }
    end
  end
    
  def new
    @current_sub_tab = 'New Article'
    @article = Article.new
    @article.build_content
  end

  def create
    @article = Article.new(params[:article])
    @article.content = Content.new(params[:article][:content_attributes].merge(:article => @article))
    @article.content.caption = @article.body
    @article.author = current_user
    @article.tag_list = params[:article][:content_attributes][:tags_string]
    @article.post_wall = params[:article][:content_attributes][:post_wall]
    @article.content.user = current_user
    if @article.save
      if @article.post_wall?
        session[:post_wall] = @article.content
      end            
      flash[:success] = "Successfully posted your article!"
      redirect_to story_path(@article.content)
    else
    	flash[:error] = "Could not create your article. Please fix the errors and try again."
    	render :new
    end
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @articles = Article.tagged_with(tag_name, :on => 'tags').active.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"

  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'articles')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'articles')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'articles')
  end

  private

  def set_current_tab
    if MENU.key? 'articles'
      @current_tab = 'articles'
    else
      @current_tab = 'stories'
    end
  end

end
