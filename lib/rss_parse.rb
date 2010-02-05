require 'open-uri'

# Had to remove the rss parse library

module RSSParse

  def self.feed_date(feed)
    ['date', 'updated', 'updated_at', 'dc_date', 'pubDate', 'lastBuildDate'].each do |date_name|
      return feed.send(date_name) if feed.respond_to? date_name
    end

    return false
  end

  def self.item_date(item)
    date = item[:date] || item[:pubDate] || item[:published] || item[:updated] || item[:updated_at] || item[:dc_date]
  end

  def self.item_body(item)
    body = item[:description] || item[:content] || item[:summary] || item[:caption] || ""
  end

  def self.item_link(item)
    link = item[:link] || item[:guid]
  end

  def self.item_title(item)
    title = item[:title] || item[:subtitle] || item[:link]
  end

  def self.item_image(item)
    image = item[:image] || item[:imageUrl] || item[:image_url] || item[:logo] || item[:icon] || ""
  end

end
