class NewswiresController < ApplicationController
  before_filter :set_current_tab
  before_filter :login_required, :only => [:quick_post]
  before_filter :load_top_stories, :only => [:index]

  def index
    @current_sub_tab = 'Browse Wires'
    @newswires = Newswire.unpublished.paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    @paginate = true
  end

  def quick_post
    @newswire = Newswire.find_by_id(params[:id])
    redirect_to newswire_path and return if @newswire.nil?

    if @newswire.quick_post(current_user.id)
      flash[:success] = "Thanks for posting a story!"
      redirect_to story_path(@newswire.content)
    else
      flash[:error] = "Could not publish your story. Please try again. #{@newswire.errors.full_messages.join '. '}"
      redirect_to newswires_path
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
