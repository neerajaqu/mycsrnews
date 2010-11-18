require 'action_controller'
include ActionController::UrlWriter

namespace :n2 do
  namespace :twitter do

    desc "Connect with Twitter"
    task :connect => :environment do
      if Metadata::Setting.find_setting('oauth_consumer_key').present? && Metadata::Setting.find_setting('oauth_consumer_secret').present? && Metadata::Setting.find_setting('oauth_consumer_key').value != 'U6qjcn193333331AuA' && Metadata::Setting.find_setting('oauth_consumer_secret').value != 'Heu0GGaRuzn762323gg0qFGWCp923viG8Haw'

        puts "Your Twitter account is already configured. Remove the variables from application_settings.yml and run again to recreate them."
      else
        if Metadata::Setting.find_setting('oauth_key').present? && Metadata::Setting.find_setting('oauth_secret').present? && Metadata::Setting.find_setting('oauth_key').value != 'U6qjcn193333331AuA' && Metadata::Setting.find_setting('oauth_secret').value != 'Heu0GGaRuzn762323gg0qFGWCp923viG8Haw'
          oauth = Twitter::OAuth.new(Metadata::Setting.find_setting('oauth_key').value, Metadata::Setting.find_setting('oauth_secret').value)
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
          
          atk = Metadata::Setting.find_setting('oauth_consumer_key')
          ats = Metadata::Setting.find_setting('oauth_consumer_secret')
          
          atk.value = oauth.access_token.token
          ats.value = oauth.access_token.secret
          atk.save
          ats.save
          
          puts "Your settings have been updated"

        else
          puts "You need to configure your Twitter OAuth settings in the admin interface."
        end
      end
    end
    
    desc "Post hot items to Twitter"
    task :post_hot_items => :environment do
      default_url_options[:host] = Metadata::Setting.find_setting('default_host').value

      if Metadata::Setting.find_setting( 'tweet_popular_items').value
        if !Metadata::Setting.find_setting('oauth_consumer_key').present? && !Metadata::Setting.find_setting('oauth_consumer_secret').present?
          puts "Your Twitter account is not configured run 'rake n2:twitter:connect'."
        else
          options =Event.options_for_tally().merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        
          event_options = Event.options_for_tally(
            {   :at_least => Metadata::Setting.find_setting( 'tweet_events_min_votes').value, 
                :at_most => 1000,  
                :start_at => 1.day.ago,
                :limit => Metadata::Setting.find_setting('tweet_events_limit').value,
                :order => "events.created_at desc"
            }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
        
          @events = Event.find(:all, event_options)
          # 
          # article_options = Article.options_for_tally(
          #   {   :at_least => APP_CONFIG['tweet_articles_min_votes'], 
          #       :at_most => 1000,  
          #       :start_at => 1.day.ago,
          #       :limit => APP_CONFIG['tweet_articles_limit'],
          #       :order => "articles.created_at desc"
          #   }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
          # @articles = Article.find(:all, article_options)

          story_options = Content.options_for_tally(
            {   :at_least =>Metadata::Setting.find_setting('tweet_stories_min_votes').value, 
                :at_most => 1000,  
                :start_at => 1.day.ago,
                :limit => Metadata::Setting.find_setting('tweet_stories_limit').value,
                :order => "contents.created_at desc"
            }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
          @stories = Content.find(:all, content_options)
                
          question_options = Question.options_for_tally(
            {   :at_least => Metadata::Setting.find_setting('tweet_questions_min_votes').value, 
                :at_most => 1000,  
                :start_at => 1.day.ago,
                :limit => Metadata::Setting.find_setting('tweet_questions_limit').value,
                :order => "questions.created_at desc"
            }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})  
          @questions = Question.find(:all, question_options)
        
          idea_options = Idea.options_for_tally(
            {   :at_least => Metadata::Setting.find_setting('tweet_ideas_min_votes').value, 
                :at_most => 1000,  
                :start_at => 1.day.ago,
                :limit => Metadata::Setting.find_setting('tweet_ideas_limit').value,
                :order => "ideas.created_at desc"
            }).merge({:include => [:tweeted_item], :conditions=>"tweeted_items.item_id IS NULL"})
          @ideas = Idea.find(:all, idea_options)
          
          oauth = Twitter::OAuth.new(Metadata::Setting.find_setting('oauth_key').value, Metadata::Setting.find_setting('oauth_secret').value)
          oauth.authorize_from_access(Metadata::Setting.find_setting('oauth_consumer_key').value, Metadata::Setting.find_setting('oauth_consumer_secret').value)
          twitter = Twitter::Base.new(oauth)  
        
          tweet_events(twitter, @events)
          tweet_questions(twitter, @questions)
          tweet_ideas(twitter, @ideas)
          # tweet_articles(twitter, @articles)
          tweet_stories(twitter, @stories)
        end
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

# def tweet_articles(twitter, articles)
#   articles.each do |article|
#     msg = "#{article.content.title} #{shorten_url(story_url(article.content))}"
#     tweet(twitter, msg)
#     article.create_tweeted_item
#   end
# end

def tweet_stories(twitter,stories)
  stories.each do |story|
    msg = "#{story.title} #{shorten_url(story_url(story))}"
    tweet(twitter,msg)
    story.create_tweeted_item
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
  if Metadata::Setting.find_setting('bitly_username').present?
    bitly = Bitly.new(Metadata::Setting.find_setting('bitly_username').value, Metadata::Setting.find_setting('bitly_api_key').value)
    shrt = bitly.shorten(url)
    return shrt.short_url
  else
    return url
  end  
end