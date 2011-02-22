require 'amazon/ecs'

module Newscloud
  module AmazonSearch

    def self.load_config
      Rails.logger.debug "Loading amazon config"
      puts "Loading amazon config"
      aws_access_key_id = Metadata::Setting.get 'aws_access_key_id', 'amazon'
      aws_secret_key = Metadata::Setting.get 'aws_secret_key', 'amazon'
      raise "Amazon keys not configured" unless aws_access_key_id and aws_secret_key
      Amazon::Ecs.options = {:aWS_access_key_id => aws_access_key_id.value, :aWS_secret_key => aws_secret_key.value, :response_group => "Large"}
      @config = Amazon::Ecs.options
    end

    def self.item_search(keywords, category = 'Books')
      self.load_config unless @config
    	res = Amazon::Ecs.item_search(keywords, :search_index => category)
    	items = []
    	res.items.each do |search_item|
    	  item = {}
    	  item[:title] = search_item.get("itemattributes/title")
    	  item[:detail_page_url] = search_item.get("detailpageurl")
    	  item[:asin] = search_item.get("asin")
    	  item[:url] = "http://amazon.com/dp/#{item[:asin]}"
    	  thumbimage = search_item.get_hash("smallimage")
    	  fullimage = search_item.get_hash("largeimage")
    	  item[:thumb_image_url] = thumbimage ? thumbimage[:url] : nil
    	  item[:full_image_url] = fullimage ? fullimage[:url] : nil

    	  items.push item
    	end
    	items
    end

  end
end
