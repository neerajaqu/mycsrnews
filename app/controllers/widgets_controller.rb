class WidgetsController < ApplicationController

  before_filter :get_parameters
  
  def get_parameters
    @count = (params[:count] ? params[:count] : 5)
    @sort = (params[:sort] ? params[:sort] : "newest")
    @filter = (params[:filter] ? params[:filter] : false)
    @scrollable = (params[:scrollable] ? true : false)
    @fan = (params[:fan] ? true : false)
  end
  
  def activities
    @activity_list = Content.articles.published.newest @count
    @title = t('widgets.activities_title', :site_title => get_setting('site_title').value)
  end
  
  def articles    
    unless @filter
      case @sort      
        when "newest"
          @article_list = Content.articles.published.newest @count
          @title = t('widgets.articles_newest_title', :site_title => get_setting('site_title').value)
        when "top"
          @article_list = Content.articles.published.top @count
          @title = t('widgets.articles_top_title', :site_title => get_setting('site_title').value)
      end
    else
      @article_list = Content.articles.featured @count
      @title = t('widgets.articles_featured_title', :site_title => get_setting('site_title').value)      
    end
  end

  def stories
    unless @filter
      case @sort
        when "newest"
          @contents = Content.active.newest @count
          @title = t('widgets.contents_newest_title', :site_title => get_setting('site_title').value)
        when "top"
          @contents = Content.active.top @count
          @title = t('widgets.contents_top_title', :site_title => get_setting('site_title').value)
      end
    else
      @contents = Content.featured @count
      @title = t('widgets.contents_featured_title', :site_title => get_setting('site_title').value)      
    end
  end
  
end
