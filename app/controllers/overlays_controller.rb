class OverlaysController < ApplicationController
  layout "overlay"
  
  def tweet
    @text = Rack::Utils.unescape(params[:text])
    if APP_CONFIG['bitly_username'].present?
      bitly = Bitly.new(APP_CONFIG['bitly_username'], APP_CONFIG['bitly_api_key'])
      shrt = bitly.shorten(Rack::Utils.unescape(params[:link]))
      @link = shrt.short_url
    else
      @link =Rack::Utils.unescape(params[:link])
    end
  end
end
