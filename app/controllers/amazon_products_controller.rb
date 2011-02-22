class AmazonProductsController < ApplicationController
  before_filter :set_categories
  def search
    @keywords = params[:keywords]
    @category = params[:category] || 'Books'
    if request.post?
    	@items = Newscloud::AmazonSearch.item_search(@keywords, @category)
    end
  end

  private

    def set_categories
      @categories = ["Apparel", "Baby", "Beauty", "Blended", "Books", "Classical", "DigitalMusic", "DVD", "Electronics", "GourmetFood", "HealthPersonalCare", "Jewelry", "Kitchen", "Magazines", "Merchants", "Miscellaneous", "Music", "MusicalInstruments", "MusicTracks", "OfficeProducts", "OutdoorLiving", "PCHardware", "Photo", "Restaurants", "Software", "SportingGoods", "Tools", "Toys", "VHS", "Video", "VideoGames", "Wireless", "WirelessAccessories"]
    end
end
