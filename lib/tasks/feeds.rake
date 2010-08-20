require 'feed_parser'


namespace :n2 do
  namespace :feeds do
    namespace :parse do
      desc "Parse All Feeds"
      task :all => :environment do
        N2::FeedParser.update_feeds
      end

      desc "Parse One Feed from 'feed_id'"
      task :one => :environment do
        raise "This task expects feed_id to be provied with an integer" unless ENV.include?("feed_id")
        feed = Feed.find_by_id ENV["feed_id"]
        raise "Invalid feed id." unless feed

        N2::FeedParser.update_feed feed
      end
    end
  end
end
