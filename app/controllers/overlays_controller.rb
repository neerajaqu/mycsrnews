class OverlaysController < ApplicationController
  layout "overlay"
  
  def tweet
    if params[:text]
      @text = Rack::Utils.unescape(params[:text]).gsub("'"," ") #remove the one character that will make twitter lib explode
      @link =Rack::Utils.unescape(params[:link])
    else
      render :text=>"" and return
    end
  end
end


