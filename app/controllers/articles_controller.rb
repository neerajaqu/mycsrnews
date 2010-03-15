class ArticlesController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:new, :create]
  before_filter :load_top_stories, :only => [:index]
  before_filter :load_top_discussed_stories, :only => [:index]
  before_filter :load_newest_articles, :only => [:index]
  
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
    @article.content.user = current_user
    if @article.save
      flash[:success] = "Successfully posted your story!"
      redirect_to story_path(@article.content)
    else
    	flash[:error] = "Could not create your article. Please fix the errors and try again."
    	render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

end
