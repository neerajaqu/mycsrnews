require 'feed_parser'
require 'magic_parse'
require 'action_controller'
include ActionController::UrlWriter

namespace :n2 do
  namespace :twitter do

    desc "Connect with Twitter"
    task :connect => :environment do
      
      if APP_CONFIG['twitter_oauth_consumer_key'].present? && APP_CONFIG['twitter_oauth_consumer_secret'].present?
        puts "Your Twitter account is already configured. Remove the variables from application_settings.yml and run again to recreate them."
      else
        if APP_CONFIG['twitter_oauth_key'].present? && APP_CONFIG['twitter_oauth_secret'].present?
          oauth = Twitter::OAuth.new(APP_CONFIG['twitter_oauth_key'], APP_CONFIG['twitter_oauth_secret'])
          request_token = oauth.request_token
          puts "please go to this twitter URL to authorize, then enter the PIN code..."
          puts "#{oauth.request_token.authorize_url}"

          pin = STDIN.gets.chomp
          
          begin
            oauth.authorize_from_request(request_token.token, request_token.secret, pin)

            twitter = Twitter::Base.new(oauth)
            twitter.user_timeline.each do |tweet|
              puts "Last tweet was from #{tweet.user.screen_name} and said #{tweet.text}"
            end
          rescue OAuth::Unauthorized
            puts "> FAIL!"
          end
          
          APP_CONFIG["twitter_oauth_consumer_key"] = oauth.access_token.token
          APP_CONFIG["twitter_oauth_consumer_secret"] = oauth.access_token.secret
          
          puts "Please copy and paste these into your application_settings.yml file: \n
                twitter_oauth_consumer_key: '#{APP_CONFIG["twitter_oauth_consumer_key"]}' \n
                twitter_oauth_consumer_secret: '#{APP_CONFIG["twitter_oauth_consumer_secret"]}'\n"
          # File.open(APPLICATION_CONFIGURATION_FILE_LOCATION, 'w') do |out|
          #   YAML.dump(APP_CONFIG, out)
          # end
        else
          puts "You need to configure your Twitter OAuth settings in application_settings.yml"
        end
      end
    end
    
    desc "Post hot items to Twitter"
    task :post_hot_items => :environment do
      default_url_options[:host] = APP_CONFIG['default_host']
      
      if !APP_CONFIG['twitter_oauth_consumer_key'].present? && !APP_CONFIG['twitter_oauth_consumer_secret'].present?
        puts "Your Twitter account is not configured run 'rake n2:twitter:connect'."
      else
        options =Event.options_for_tally().merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        
        event_options = Event.options_for_tally(
          {   :at_least => APP_CONFIG['tweet_events_min_votes'], 
              :at_most => 1000,  
              :start_at => 1.day.ago,
              :limit => APP_CONFIG['tweet_events_limit'],
              :order => "events.created_at desc"
          }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        
        @events = Event.find(:all, event_options)
        
        article_options = Article.options_for_tally(
          {   :at_least => APP_CONFIG['tweet_articles_min_votes'], 
              :at_most => 1000,  
              :start_at => 1.day.ago,
              :limit => APP_CONFIG['tweet_articles_limit'],
              :order => "articles.created_at desc"
          }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        @articles = Article.find(:all, article_options)
        
        question_options = Question.options_for_tally(
          {   :at_least => APP_CONFIG['tweet_questions_min_votes'], 
              :at_most => 1000,  
              :start_at => 1.day.ago,
              :limit => APP_CONFIG['tweet_questions_limit'],
              :order => "questions.created_at desc"
          }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})  
        @questions = Question.find(:all, question_options)
        
        idea_options = Idea.options_for_tally(
          {   :at_least => APP_CONFIG['tweet_ideas_min_votes'], 
              :at_most => 1000,  
              :start_at => 1.day.ago,
              :limit => APP_CONFIG['tweet_ideas_limit'],
              :order => "ideas.created_at desc"
          }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        @ideas = Idea.find(:all, idea_options)
          
        oauth = Twitter::OAuth.new(APP_CONFIG['twitter_oauth_key'], APP_CONFIG['twitter_oauth_secret'])
        oauth.authorize_from_access(APP_CONFIG['twitter_oauth_consumer_key'], APP_CONFIG['twitter_oauth_consumer_secret'])
        twitter = Twitter::Base.new(oauth)  
        
        tweet_events(twitter, @events)
        tweet_questions(twitter, @questions)
        tweet_ideas(twitter, @ideas)
        tweet_articles(twitter, @articles)
      end
    end



  end
end

def tweet_events(twitter, events)
  events.each do |event|
    msg = "#{event.name} #{shorten_url(event_url(event))}"
    tweet(twitter, msg)
    event.create_tweeted_item
  end

end

def tweet_articles(twitter, articles)
  articles.each do |article|
    msg = "#{article.content.title} #{shorten_url(story_url(article.content))}"
    tweet(twitter, msg)
    article.create_tweeted_item
  end
end

def tweet_questions(twitter, questions)
  questions.each do |question|
    msg = "#{question.question} #{shorten_url(question_url(question))}"
    tweet(twitter, msg)
    question.create_tweeted_item
  end
end

def tweet_ideas(twitter, ideas)
  ideas.each do |idea|
    msg = "#{idea.title} #{shorten_url(idea_url(idea))}"
    tweet(twitter, msg)
    idea.create_tweeted_item
  end
end

def tweet(twitter, msg)
  twitter.update(msg)
end

def shorten_url(url)
  if APP_CONFIG['bitly_username'].present?
    bitly = Bitly.new(APP_CONFIG['bitly_username'], APP_CONFIG['bitly_api_key'])
    shrt = bitly.shorten(url)
    return shrt.short_url
  else
    return ulr
  end  
end