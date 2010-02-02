require 'simple-rss'
require 'open-uri'

namespace :n2 do
  namespace :feeds do
    namespace :parse do
      desc "Parse All Feeds"
      task :all => :environment do
        feeds = Feed.find(:all, :conditions => ["specialType = ?", "default"])

        feeds.each { |f| update_feed f }
      end

      desc "Parse One Feed from 'feed_id'"
      task :one => :environment do
        raise "This task expects feed_id to be provied with an integer" unless ENV.include?("feed_id")
        feed = Feed.find_by_id ENV["feed_id"]
        raise "Invalid feed id." unless feed.present?

        update_feed feed
      end
    end
  end
end

def update_feed(feed)
  begin
    rss = SimpleRSS.parse open(feed.rss)
  rescue => e
    puts "Failed to open feed at #{feed.url} -- #{e}" or return false
  end

  puts "The feed #{feed.title}(#{feed.url}) is presently invalid." or return false unless rss.present?
  puts "The feed #{feed.title}(#{feed.url}) is presently empty." or return false unless rss.items.present?

  date = RSSParse.feed_date rss
  puts "Parsing #{feed.title} with #{rss.items.size} items -- updated on #{date}"
  # TODO:: fix feed.lastFetch
  feed_date = feed.updated_at || feed.created_at || feed.lastFetch
  feed_date = feed.lastFetch if feed.updated_at == feed.created_at
  if date and feed_date < date
    rss.items.each do |item|
      item_date = RSSParse.item_date item
      break if item_date <= feed_date

      body  = RSSParse.item_body item
      link  = RSSParse.item_link item
      title = RSSParse.item_title item
      image = RSSParse.item_image item

      next unless body and link and title and date

      puts "\tCreating newswire for #{title}"

      Newswire.create!({
        :title      => title,
        :caption    => body,
        :created_at => item_date,
        :url        => link,
        :imageUrl   => image,
        :feed       => feed
      })
    end

    feed.update_attributes(:updated_at => Time.now)
  end
end
