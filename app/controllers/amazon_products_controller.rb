class AmazonProductsController < ApplicationController
  before_filter :set_categories
  def search
    @keywords = params[:keywords]
    @category = params[:category] || 'Books'
    if request.post?
    	res = Amazon::Ecs.item_search(@keywords, :search_index => @category)
    	@items = []
    	res.items.each do |item|
    	  istruct = OpenStruct.new
    	  istruct.title = item.get("itemattributes/title")
    	  istruct.url = item.get("detailpageurl")
    	  images = item.get_hash("smallimage")
    	  if images
          istruct.thumb_url = item.get_hash("smallimage")[:url]
        else
          istruct.thumb_url = nil
        end

    	  @items.push istruct
    	end
    end
  end

  private

    def set_categories
      @categories = ["Apparel", "Baby", "Beauty", "Blended", "Books", "Classical", "DigitalMusic", "DVD", "Electronics", "GourmetFood", "HealthPersonalCare", "Jewelry", "Kitchen", "Magazines", "Merchants", "Miscellaneous", "Music", "MusicalInstruments", "MusicTracks", "OfficeProducts", "OutdoorLiving", "PCHardware", "Photo", "Restaurants", "Software", "SportingGoods", "Tools", "Toys", "VHS", "Video", "VideoGames", "Wireless", "WirelessAccessories"]
    end
end
