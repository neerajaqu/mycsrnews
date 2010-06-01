class ForumsController < ApplicationController
  before_filter :set_current_tab

  def index
    @forums = Forum.positioned
  end

  def show
    @forum = Forum.find(params[:id])
  end

  private

  def set_current_tab
    @current_tab = 'forums'
  end

end
