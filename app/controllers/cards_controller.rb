class CardsController < ApplicationController
  before_filter :login_required

  def index
    @cards = Card.all.reverse
  end

  private

  def set_current_tab
    @current_tab = 'cards'
  end

end
