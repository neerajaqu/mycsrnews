class OverlaysController < ApplicationController
  layout "overlay"
  
  def tweet
    @text = Rack::Utils.unescape(params[:text])
    @link = Rack::Utils.unescape(params[:link])
  end
end
