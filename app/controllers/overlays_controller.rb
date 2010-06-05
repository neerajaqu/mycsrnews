class OverlaysController < ApplicationController
  layout "overlay"
  
  def tweet
    if params[:text]
      @text = Rack::Utils.unescape(params[:text]).gsub("'"," ") #remove the one character that will make twitter lib explode
      if APP_CONFIG['bitly_username'].present?
        bitly = Bitly.new(APP_CONFIG['bitly_username'], APP_CONFIG['bitly_api_key'])
        shrt = bitly.shorten(Rack::Utils.unescape(params[:link]))
        @link = shrt.short_url
      else
        @link =Rack::Utils.unescape(params[:link])
      end
    else
      render :text=>"" and return
    end
  end
end


