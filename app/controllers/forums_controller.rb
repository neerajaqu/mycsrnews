class ForumsController < ApplicationController
  before_filter :set_current_tab

  def index
    @forums = Forum.positioned
  end

  def show
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @forum = Forum.find(params[:id])
    @topics = @forum.topics.active.paginate :page => params[:page], :per_page => Topic.per_page, :order => "created_at desc"
    @paginate = true
  end

  private

  def set_current_tab
    @current_tab = 'forums'
  end

end
