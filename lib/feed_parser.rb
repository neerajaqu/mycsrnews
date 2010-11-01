require 'feedzirra'


module N2
  class FeedParser
    def self.update_feeds
      feeds = Feed.find(:all, :conditions => ["deleted_at is null and specialType = ?", "default"])
      feeds.each { |feed| update_feed feed, false }

      expire_newswire_cache
    end

    def self.update_feed(feed, trigger_expire_cache = true)
      return false unless feed
      Rails.logger.info "Running feedzirra on #{feed.item_title}"
      begin
        rss = Feedzirra::Feed.fetch_and_parse(feed.rss)
      rescue => e
        Rails.logger.info "Failed to open feed at #{feed.url} -- #{e}"
        return false
      end
      Rails.logger.info "The feed #{feed.title}(#{feed.url}) could not be reached -- status: #{rss.inspect}" and return false unless rss and rss.respond_to?(:entries)
      items = rss.entries
      Rails.logger.info "The feed #{feed.title}(#{feed.url}) is presently empty." and return false unless items.present?
      Rails.logger.info "Parsing #{feed.title} with #{items.size} items -- updated on #{rss.last_modified} -- last fetched #{feed.last_fetched_at}"

      feed_date = feed.last_fetched_at
      pub_date = rss.last_modified
      if !feed_date or (pub_date and feed_date < pub_date)
        items.each do |item|
          Rails.logger.info "\tChecking feed items"
          break if feed_date and item.published and (item.published <= feed_date)
          next if Newswire.find_by_title item.title
          item_summary = item.summary || item.content
          next unless item_summary and item.url and item.title

          Rails.logger.info "\tCreating newswire for \"#{item.title.chomp}\""

          newswire = Newswire.create!({
            :title      => item.title,
            :caption    => item_summary,
            :created_at => item.published,
            :url        => item.url,
            #:imageUrl   => item.image,
            :feed       => feed
          })
          if feed.load_all?
            Rails.logger.info "\t\tRunning quick post.."
            if newswire.imageUrl.present? and not newswire.imageUrl =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?(jpg|jpeg|gif|png)(\?.*)?$/ix
              Rails.logger.info "\t\t\tProcessing non standard image: #{newswire.imageUrl}"
              unless newswire.quick_post(nil, true)
                Rails.logger.info "\t\t\tCould not process image, skipping image."
                newswire.update_attribute(:imageUrl, nil)
                newswire.quick_post
              end
            else
              newswire.quick_post
            end
          end
        end

        feed.update_attributes({:updated_at => Time.now, :last_fetched_at => (pub_date || Time.now)})
      end

      expire_newswire_cache if trigger_expire_cache
    end

    def self.expire_newswire_cache
      Rails.logger.info "Expiring newswires cache"
      NewswireSweeper.expire_newswires
    end
  end
end
