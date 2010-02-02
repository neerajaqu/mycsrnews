class NewswiresController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:publish]
  before_filter :load_top_stories, :only => [:index]

  def index
    @newswires = Newswire.find(:all, :order => "updated_at desc", :limit => 20)
  end

  def publish
    @newswire = Newswire.find_by_id(params[:id])
    redirect_to newswire_path and return if @newswire.nil?

    @content = Content.new({
    	:title    => @newswire.title,
    	:caption  => @newswire.caption,
    	:url      => @newswire.url,
    	:source   => @newswire.feed.title,
    	:user     => current_user
    })
    unless @newswire.imageUrl.nil? or @newswire.imageUrl.empty?
      @content.build_content_image({ :url => @newswire.imageUrl })
    end
    if @content.save
      flash[:success] = "Thanks for posting a story!"
      redirect_to story_path(@content)
    else
      flash[:error] = "Could not publish your story. Please try again."
      redirect_to newswire_path
    end
  end

  private

  def set_current_tab
    @current_tab = 'newswire'
  end

end
