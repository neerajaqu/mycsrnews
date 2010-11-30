require 'active_record'

module Newscloud
  module Acts
    module Tweetable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_tweetable
          has_one :tweeted_item, :as => :item

          include Newscloud::Acts::Tweetable::InstanceMethods
          extend Newscloud::Acts::Tweetable::TweetClassMethods
        end
      end

      module TweetClassMethods
        def tweetable?
          true
        end

        def hot_items
          setting_group = self.tweet_setting_group
          min_votes = Metadata::Setting.find_setting("tweet_#{setting_group}_min_votes").try(:value) || Metadata::Setting.find_setting("tweet_default_min_votes").try(:value)
          limit = Metadata::Setting.find_setting("tweet_#{setting_group}_limit").try(:value) || Metadata::Setting.find_setting("tweet_default_limit").try(:value)
					#
					# TODO:: Fix error from this
					# ArgumentError: Unknown key(s): at_least
					#
          begin
            hot_options = self.options_for_tally(
              {   :at_least => min_votes,
                  :at_most  => 1000,  
                  :start_at => 1.day.ago,
                  :limit    => limit,
                  :order    => "#{self.table_name}.created_at desc"
              }).merge({:include => [:tweeted_item], :conditions=>"votes.voteable_type = '#{self.name}' AND tweeted_items.item_id IS NULL"})
            self.find(:all, hot_options)
          rescue Exception => e
            Rails.logger.error("ERROR: Tweet Hot Items error:: #{e}")
            return false
          end
        end

        def tweet_setting_group
          self.table_name
        end
      end

      module InstanceMethods
        def tweetable?
          true
        end

        def tweet
          Resque.enqueue(TwitterWorker, self.class.name, self.id)
        end
      end

    end
  end
end
