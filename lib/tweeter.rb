require 'action_controller'
include ActionController::UrlWriter

module Newscloud

  class TweeterDisabled < Exception
  end

  class TweeterNotConfigured < Exception
  end

  class Tweeter

    def initialize
      default_url_options[:host] = APP_CONFIG['base_url'].sub(%r{^https?://}, '')
      @base_oauth_key = "U6qjcn193333331AuA"
      @base_oauth_secret= "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw"

      @enabled = Metadata::Setting.find_setting('tweet_popular_items').try(:value)
      raise Newscloud::TweeterDisabled.new("You must enable the setting 'tweet_popular_items' to use Tweeter.") unless @enabled

      @oauth_key = Metadata::Setting.find_setting('oauth_key').try(:value)
      @oauth_secret = Metadata::Setting.find_setting('oauth_secret').try(:value)
      @oauth_consumer_key = Metadata::Setting.find_setting('oauth_consumer_key').try(:value)
      @oauth_consumer_secret =  Metadata::Setting.find_setting('oauth_consumer_secret').try(:value)

      unless @oauth_key and @oauth_consumer_key and @oauth_secret and @oauth_consumer_secret
        raise Newscloud::TweeterNotConfigured.new("You must configure your oauth settings and run the rake twitter connect task.")
      end

      if @oauth_key == @base_oauth_key or @oauth_consumer_key == @base_oauth_key or
      	 @oauth_secret == @base_oauth_secret or @oauth_consumer_secret == @base_oauth_secret
      	  raise Newscloud::TweeterNotConfigured.new("You must configure your oauth settings and run the rake twitter connect task.")
      end

      oauth = Twitter::OAuth.new(@oauth_key, @oauth_secret)
      oauth.authorize_from_access(@oauth_consumer_key, @oauth_consumer_secret)

      @twitter = Twitter::Base.new(oauth)
    end

    def tweet_items items
      items.each {|item| tweet_item(item) }
    end

    def tweet_item item
      # TODO:: setup facebook canvas url option
      status = tweet "#{item.item_title} #{self.class.shorten_url(polymorphic_path(item, :only_path => false))}"
      item.create_tweeted_item if status
    end

    def tweet msg
      begin
        @twitter.update(msg)
      rescue Exception => e
        Rails.logger.error("ERROR TWEETING: (#{msg}) -- #{e}")
        return false
      end
    end

    def tweet_hot_items
      klasses = Dir.glob("#{RAILS_ROOT}/app/models/*.rb").map {|f| f.sub(%r{^.*/(.*?).rb$}, '\1').pluralize.classify }.map(&:constantize).select {|m| m.respond_to?(:tweetable?) and m.tweetable? }
      klasses.each do |klass|
        puts "Hot items for #{klass.name.titleize}"
        puts klass.hot_items.inspect
        tweet_items klass.hot_items
      end
    end

    def self.shorten_url(url)
      @bitly_username = Metadata::Setting.find_setting('bitly_username').try(:value)
      @bitly_api_key = Metadata::Setting.find_setting('bitly_api_key').try(:value)

      if @bitly_username and @bitly_api_key
      	bitly = Bitly.new(@bitly_username, @bitly_api_key)
      	bitly.shorten(url).short_url
      else
      	url
      end
    end

  end

end
