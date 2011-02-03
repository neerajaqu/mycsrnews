class ClassifiedsController < ApplicationController

  before_filter :set_current_tab

  def index
    @current_sub_tab = 'Browse'
  end

  def show
    @current_sub_tab = 'Show'
  end

  def edit
    @current_sub_tab = 'Edit'
  end

  def my_items
    @current_sub_tab = 'My Items'
  end

  def borrowed_items
    @current_sub_tab = 'My Borrowed Items'
  end

  def set_current_tab
    @current_tab = 'classifieds'
  end

end
