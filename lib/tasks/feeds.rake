require 'feed_parser'
require 'magic_parse'

namespace :n2 do
  namespace :feeds do
    namespace :parse do
      desc "Parse All Feeds"
      task :all => :environment do
        feeds = Feed.find(:all, :conditions => ["specialType = ?", "default"])

        feeds.each { |f| update_feed f }

        NewswireSweeper.expire_newswires
      end

      desc "Parse One Feed from 'feed_id'"
      task :one => :environment do
        raise "This task expects feed_id to be provied with an integer" unless ENV.include?("feed_id")
        feed = Feed.find_by_id ENV["feed_id"]
        raise "Invalid feed id." unless feed.present?

        update_feed feed

        NewswireSweeper.expire_newswires
      end
    end
  end
end

def update_feed(feed)
  return new_update_feed(feed) if (feed.load_all? and feed.loadOptions == 'full_html') or feed.loadOptions == 'magic_parse'
  begin
     #rss = RSS::Parser.parse(open(feed.rss).read, false)
     rss = FeedParser.new(feed.rss)
  rescue => e
    puts "Failed to open feed at #{feed.url} -- #{e}"
    return false
  end

  puts "The feed #{feed.title}(#{feed.url}) is presently invalid." or return false unless rss.present?
  puts "The feed #{feed.title}(#{feed.url}) is presently empty." or return false unless rss.items.present?

  puts "Parsing #{feed.title} with #{rss.items.size} items -- updated on #{rss.date} -- last fetched #{feed.last_fetched_at}"

  feed_date = feed.last_fetched_at
  if !feed_date or (rss.date and feed_date < rss.date)
    rss.items.each do |item|
      break if feed_date and item[:date] <= feed_date
      next if Newswire.find_by_title item[:title]
      next unless item[:body] and item[:link] and item[:title] and item[:date]

      puts "\tCreating newswire for \"#{item[:title].chomp}\""

      newswire = Newswire.create!({
        :title      => item[:title],
        :caption    => item[:body],
        :created_at => item[:date].to_s,
        :url        => item[:link],
        :imageUrl   => item[:image],
        :feed       => feed
      })
      if feed.load_all?
      	puts "\t\tRunning quick post"
      	newswire.quick_post
      end
    end

    feed.update_attributes({:updated_at => Time.now, :last_fetched_at => rss.date.to_s})
  end
end

def new_update_feed(feed)
  puts "Running full parse on #{feed.title}"
  rss = MagicParse.new(feed.rss)
  items = rss.get_items
  puts "The feed #{feed.title}(#{feed.url}) is presently empty." or return false unless items.present?
  puts "Parsing #{feed.title} with #{items.size} items -- updated on #{rss.get_pub_date} -- last fetched #{feed.last_fetched_at}"

  feed_date = feed.last_fetched_at
  pub_date = Time.parse(rss.get_pub_date)
  if !feed_date or (pub_date and feed_date < pub_date)
    items.each do |item|
      break if feed_date and Time.parse(item[:date]) <= feed_date
      next if Newswire.find_by_title item[:title]
      next unless item[:body] and item[:link] and Time.parse(item[:title]) and item[:date]

      puts "\tCreating newswire for \"#{item[:title].chomp}\""

      newswire = Newswire.create!({
        :title      => item[:title],
        :caption    => item[:body],
        :created_at => item[:date].to_s,
        :url        => item[:link],
        :imageUrl   => item[:image],
        :feed       => feed
      })
      if feed.load_all?
      	puts "\t\tRunning quick post.."
      	if newswire.imageUrl.present? and not newswire.imageUrl =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?(jpg|jpeg|gif|png)(\?.*)?$/ix
      	  puts "\t\t\tProcessing non standard image: #{newswire.imageUrl}"
          unless newswire.quick_post(nil, true)
            puts "\t\t\tCould not process image, skipping image."
            newswire.update_attribute(:imageUrl, nil)
            newswire.quick_post
          end
        else
          newswire.quick_post
        end
      end
    end

    feed.update_attributes({:updated_at => Time.now, :last_fetched_at => (pub_date.to_s || Time.now)})
  end
end
