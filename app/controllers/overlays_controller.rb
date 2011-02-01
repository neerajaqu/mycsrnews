class OverlaysController < ApplicationController
  # NOTE:: current overlay layout reloads javascript and breaks overlays
  # to use a layout for overlays, we need to remove duplication
  # layout "overlay"
  layout false
  
  def tweet
    if params[:text]
      @text = Rack::Utils.unescape(params[:text]).gsub("'"," ") #remove the one character that will make twitter lib explode
      @link =Rack::Utils.unescape(params[:link])
    else
      render :text=>"" and return
    end
  end
end


