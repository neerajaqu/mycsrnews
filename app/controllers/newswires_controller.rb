class NewswiresController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:quick_post]
  before_filter :load_top_stories, :only => [:index]

  def index
    @current_sub_tab = 'Browse Wires'
    #@newswires = Newswire.find(:all, :order => "updated_at desc", :limit => 200)
    @newswires = Newswire.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    @paginate = true
  end

  def quick_post
    @newswire = Newswire.find_by_id(params[:id])
    redirect_to newswire_path and return if @newswire.nil?

    @content = Content.new({
    	:title    => @newswire.title,
    	:caption  => @template.strip_tags(@newswire.caption),
    	:url      => @newswire.url,
    	:source   => @newswire.feed.title,
    	:user     => current_user
    })
    unless @newswire.imageUrl.nil? or @newswire.imageUrl.empty?
      @content.images.build({ :remote_image_url => @newswire.imageUrl })
    end
    if @content.save
      flash[:success] = "Thanks for posting a story!"
      redirect_to story_path(@content)
    else
      flash[:error] = "Could not publish your story. Please try again."
      redirect_to newswire_path
    end
  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'newswires')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'newswires')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'newswires')
  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

end
