class GoController < ApplicationController

  def show
    @go = Go.active.find(params[:id])
    if @go
      @go.viewed!
      redirect_to @go.goable
    else
      flash[:error] = "Item not found"
      redirect_to home_path
    end
  end

end
