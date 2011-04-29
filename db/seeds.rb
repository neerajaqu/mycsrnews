# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# set debug flag
debug = Rails.env.development?

# Initial Topic Sections
IdeaBoard.create!({:name => 'General', :section =>'general',:description=>'General ideas.'}) unless IdeaBoard.find_by_name_and_section('General', 'general')
ResourceSection.create!({:name => 'General', :section =>'general',:description=>'General links.'}) unless ResourceSection.find_by_name_and_section('General', 'general')
if Forum.count == 0
  Forum.create!({:name => 'General', :description=>'Talk about whatever you want. This area is for open discussion.'}) unless Forum.find_by_name('General')
  Forum.create!({:name => 'Feedback', :description=>"Tell us how we're doing. Share your thoughts about #{APP_CONFIG['site_title']}!"}) unless Forum.find_by_name('Feedback')
end
# Initial Classified Categories
["Appliances", "Antiques and Collectibles", "Bikes", "Boats", "Books", "Business", "Computer", "Furniture", "General", "Jewelry", "Materials", "Sporting", "Tickets", "Tools", "Arts and Crafts", "Auto Parts", "Baby and Kids", "Beauty and Health", "Cars and Trucks", "Cds, Dvd, Vhs", "Cell Phones", "Clothes", "Electronics", "Garden", "Household", "Motorcycles", "Musical Instruments", "Photo and Video", "Toys", "Video Games", "Gaming"].each do |category|
  Classified.add_category(category) unless Classified.categories.find_by_name(category)
end

#TODO:: - fix (User.admins.last || nil) - creates fb user as nil, bombs out in fb helper for profilepic

# Default Prediction Group 
#if PredictionGroup.count == 0
#  PredictionGroup.create!({:title => 'Other', :section => 'other', :description => 'This topic is for uncategorized questions'}) unless PredictionGroup.find_by_title_and_section('Other','other')
#end

# Populate Sources table with some commonly used sites
Source.create!({:name => 'New York Times', :url =>'nytimes.com'}) unless Source.find_by_url('nytimes.com')
Source.create!({:name => 'Los Angeles Times', :url =>'latimes.com'}) unless Source.find_by_url('latimes.com')
Source.create!({:name => 'Chicago Tribune', :url =>'chicagotribune.com'}) unless Source.find_by_url('chicagotribune.com')
Source.create!({:name => 'National Public Radio', :url =>'npr.org'}) unless Source.find_by_url('npr.org')

# Create Metadata Settings
ads = [
  { :key_name => 'default', :key_sub_type => 'banner', :width => "468px", :height => "60px", :background => "default/ads_468_60.gif" },
  { :key_name => 'default', :key_sub_type => 'leaderboard', :width => "728px", :height => "90px", :background => "default/ads_728_90.gif" },
  { :key_name => 'default', :key_sub_type => 'small_square', :width => "200px", :height => "200px", :background => "default/ads_200_200.gif" },
  { :key_name => 'default', :key_sub_type => 'skyscraper', :width => "160px", :height => "600px", :background => "default/ads_160_600.gif" },
  { :key_name => 'default', :key_sub_type => 'square', :width => "250px", :height => "250px", :background => "default/ads_250_250.gif" },
  { :key_name => 'default', :key_sub_type => 'medium_rectangle', :width => "300px", :height => "250px", :background => "default/ads_300_250.gif" },
  { :key_name => 'default', :key_sub_type => 'large_rectangle', :width => "336px", :height => "280px", :background => "default/ads_336_280.gif" }
]
ads.each do |ad|
  next if Metadata::Ad.find_slot(ad[:key_sub_type], ad[:key_name])
  puts "Creating ad slot #{ad[:key_name]} -- #{ad[:key_sub_type]}" if debug

  Metadata::Ad.create!({
    :meta_type => 'config',
    :key_type => 'ads',
    :key_sub_type => ad[:key_sub_type],
		:key_name => ad[:key_name],
		:data => { :name => (ad[:name] || "slot_#{ad[:key_sub_type]}"),
      :width => ad[:width],
      :height => ad[:height],
      :background => ad[:background]
    }
  })
end

custom_widgets = [
  { :key_name => 'events', :key_sub_type => 'sidebar', :title => "events custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'stories', :key_sub_type => 'sidebar', :title => "stories custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'articles', :key_sub_type => 'sidebar', :title => "stories custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'resources', :key_sub_type => 'sidebar', :title => "resources custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'ideas', :key_sub_type => 'sidebar', :title => "ideas custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'home', :key_sub_type => 'sidebar', :title => "home custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'questions', :key_sub_type => 'sidebar', :title => "questions custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'cards', :key_sub_type => 'sidebar', :title => "cards custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' },
  { :key_name => 'forums', :key_sub_type => 'sidebar', :title => "forums custom sidebar widget", :content_type => "sidebar_content", :custom_data => '**default**' }
]
custom_widgets.each do |custom_widget|
  next if Metadata::CustomWidget.find_slot(custom_widget[:key_sub_type], custom_widget[:key_name])
  puts "Creating custom_widget slot #{custom_widget[:title]} -- #{custom_widget[:key_sub_type]}" if debug

  Metadata::CustomWidget.create!({
    :meta_type => 'custom',
    :key_type => 'widget',
    :key_sub_type => custom_widget[:key_sub_type],
		:key_name => custom_widget[:key_name],
		:data => {
      :title => custom_widget[:title],
      :content_type => custom_widget[:content_type],
      :custom_data => custom_widget[:custom_data]
    }
  })
end

settings = [
 { :key_sub_type => 'amazon', :key_name => 'aws_access_key_id',  :value => "1234asdf4321" },
 { :key_sub_type => 'amazon', :key_name => 'aws_secret_key',  :value => "123454321asdf5432112345" },
 { :key_sub_type => 'amazon', :key_name => 'associate_code',  :value => "yourcode-20" },
 { :key_sub_type => 'options', :key_name => 'default_admin_user',  :value => (APP_CONFIG['default_admin_user'] || "admin") },
 { :key_sub_type => 'options', :key_name => 'default_admin_password',  :value => (APP_CONFIG['default_admin_password'] || "n2adminpassword") },
 { :key_sub_type => 'options', :key_name => 'default_site_preference',  :value => "iframe" },
 { :key_sub_type => 'options', :key_name => 'animation_speed_features',  :value => "300" },
 { :key_sub_type => 'options', :key_name => 'animation_speed_newswires',  :value => "750" },
 { :key_sub_type => 'options', :key_name => 'animation_speed_widgets',  :value => "1000" },
 { :key_sub_type => 'options', :key_name => 'animation_interval_general',  :value => "1000" },
 { :key_sub_type => 'options', :key_name => 'animation_interval_newswires',  :value => "1000" },
 { :key_sub_type => 'options', :key_name => 'exclude_articles_from_news',  :value => "false" },
 { :key_sub_type => 'options', :key_name => 'auto_feature_only_moderator_items',  :value => "false", :hint => "Filter auto feature widgets to only use items posted by moderators" },
 { :key_sub_type => 'options', :key_name => 'outbrain_enabled',  :value => "false", :hint => "Enable Outbrain(http://outbrain.com) support" },
 { :key_sub_type => 'options', :key_name => 'outbrain_template_name',  :value => "my_template_name", :hint => "Outbrain template name" },
 { :key_sub_type => 'options', :key_name => 'outbrain_account_id',  :value => "1234567890", :hint => "Outbrain account id" },
 { :key_sub_type => 'options', :key_name => 'outbrain_verification_html',  :value => "false", :hint => "Outbrain verification html, copy paste this from Outbrain." },
 { :key_sub_type => 'options', :key_name => 'hoptoad_api_key',  :value => (APP_CONFIG['hoptoad_api_key'] || "false" ), :hint => "API Key for tracking bugs via HopToadApp" },
 #{ :key_sub_type => 'options', :key_name => 'site_notification_user',  :value => (User.admins.last || nil) },
 { :key_sub_type => 'options', :key_name => 'enable_activity_popups',  :value => "true" },
 { :key_sub_type => 'options', :key_name => 'allow_web_auth',  :value => (APP_CONFIG['allow_web_auth'] || "false" ) },
 { :key_sub_type => 'options', :key_name => 'site_title',  :value => (APP_CONFIG['site_title'] || "Default Site Title" ) },
 { :key_sub_type => 'options', :key_name => 'site_topic', :value => (APP_CONFIG['site_topic'] || "Default Topic" ) },
 { :key_sub_type => 'options', :key_name => 'contact_us',  :value => (APP_CONFIG['contact_us_recipient'] || "admin@email.com,me@email.com,support@email.com" ) },
 { :key_sub_type => 'options', :key_name => 'firstnameonly', :value => (APP_CONFIG['firstnameonly'] || "false" ) },
 { :key_sub_type => 'options', :key_name => 'site_video_url', :value => APP_CONFIG['base_site_url'].gsub("http://","").gsub("www",""), :hint => "used by some sites with custom video URLs e.g. boston.com"},
 { :key_sub_type => 'options', :key_name => 'predictions_max_daily_guesses', :value => 25, :hint => "maximum number of guesses allowed per day"},
 { :key_sub_type => 'options', :key_name => 'predictions_allow_suggestions',  :value => true },
 { :key_sub_type => 'design', :key_name => 'typekit', :value => (APP_CONFIG['typekit'] || "000000" ) },
 { :key_sub_type => 'twitter', :key_name => 'account', :value =>(APP_CONFIG['twitter_account'] || "userkey_name" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_key', :value => (APP_CONFIG['twitter_oauth_key'] || "U6qjcn193333331AuA" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_secret', :value => (APP_CONFIG['twitter_oauth_secret'] || "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_consumer_key', :value => (APP_CONFIG['twitter_oauth_key'] || "U6qjcn193333331AuA" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_consumer_secret', :value => (APP_CONFIG['twitter_oauth_secret'] || "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_default_min_votes', :value => (APP_CONFIG['tweet_default_min_votes'] || "15" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_default_limit', :value => (APP_CONFIG['tweet_default_limit'] || "3" ) }, 
 { :key_sub_type => 'twitter', :key_name => 'tweet_events_min_votes', :value => (APP_CONFIG['tweet_events_min_votes'] || "15" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_events_limit', :value => (APP_CONFIG['tweet_events_limit'] || "3" ) }, 
 { :key_sub_type => 'twitter', :key_name => 'tweet_stories_min_votes', :value => (APP_CONFIG['tweet_stories_min_votes'] || "15" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_stories_limit', :value => (APP_CONFIG['tweet_stories_limit'] || "3" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_questions_min_votes', :value => (APP_CONFIG['tweet_questions_min_votes'] || "15" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_questions_limit', :value => (APP_CONFIG['tweet_questions_limit'] || "3" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_ideas_min_votes', :value => (APP_CONFIG['tweet_ideas_min_votes'] || "15" ) },
 { :key_sub_type => 'twitter', :key_name => 'tweet_ideas_limit', :value => (APP_CONFIG['tweet_ideas_limit'] || "3" ) },   
 { :key_sub_type => 'twitter', :key_name => 'tweet_featured_items', :value =>(APP_CONFIG['tweet_featured_items'] || "true" ) }, 
 { :key_sub_type => 'twitter', :key_name => 'tweet_popular_items', :value =>"false" }, 
 { :key_sub_type => 'twitter', :key_name => 'tweet_all_moderator_items', :value =>"false", :hint => 'Tweet all items posted by moderators' }, 
 { :key_sub_type => 'bitly', :key_name => 'bitly_username', :value =>(APP_CONFIG['bitly_username'] || "username" ) },
 { :key_sub_type => 'bitly', :key_name => 'bitly_api_key', :value =>(APP_CONFIG['bitly_api_key'] || "api_key" ) },
 { :key_sub_type => 'facebook', :key_name => 'app_id', :value => (APP_CONFIG['facebook_application_id'] || "111111111111" ) },
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_layout', :value => "default", :hint => 'e.g. default, thumb, host, banner' },
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_image_url', :value => APP_CONFIG['base_site_url']+"/images/default/icon-fan-app.gif", :hint => "Full (absolute) URL to image, e.g. #{APP_CONFIG['base_site_url']}/images/default/icon-fan-app.gif, recommended sizes: thumb 50 x 50 or banner = 300 x 90"},
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_host', :value => "0", :hint => 'userid of host profile image to use'},
 { :key_sub_type => 'options', :key_name => 'limit_daily_member_posts',  :value => "25" },
 { :key_sub_type => 'stats', :key_name => 'google_analytics_account_id', :value => (APP_CONFIG['google_analytics_account_id'] || "UF-123456890-7" ) },
 { :key_sub_type => 'stats', :key_name => 'google_analytics_site_id', :value => (APP_CONFIG['google_analytics_site_id'] || "1231232" ) },
 { :key_sub_type => 'sitemap', :key_name => 'google-site-verification', :value => "WS8kMC8-Ds77777777777Xy6QcmRpWAfY" },
 { :key_sub_type => 'sitemap', :key_name => 'yahoo-site-verification', :value => "WS87ds77" },
 { :key_sub_type => 'sitemap', :key_name => 'yahoo_app_id',  :value => (APP_CONFIG['yahoo_app_id'] || "ELIZq2L333322.rGdRR5abc888HCGL1zDOegJakZyHIrugVqPip3YK333P8-") },
 { :key_sub_type => 'ads', :key_name => 'sponsor_zones_enabled', :value => "false" },
 { :key_sub_type => 'ads', :key_name => 'sponsor_zones_store_url', :value => "http://newscloud.trafficspaces.com", :hint => "The website URL used to sell your sponsored ad zones"  },
 { :key_sub_type => 'ads', :key_name => 'platform', :value => (APP_CONFIG['ad_platform'] || "none" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_sitepage', :value => (APP_CONFIG['helios_sitepage'] || "youraddomain.com/yourfacebookproject.htm" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_url', :value => (APP_CONFIG['helios_url'] || "http://subdomain.xxx.com" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_script_url', :value => (APP_CONFIG['helios_script_url'] || "http://scriptsubdomain.xxx.com" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_list_pos', :value => (APP_CONFIG['helios_list_pos'] || "728x90_1,468x60_1,300x250_1,160x600_1,250x250_1,200x200_1,336x280_1" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_slot_name', :value => (APP_CONFIG['helios_slot_name'] || "default" ) },
 { :key_sub_type => 'ads', :key_name => 'openx_slot_name', :value => (APP_CONFIG['openx_slot_name'] || "default" ) },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_banner', :value => "1" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_leaderboard', :value => "2" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_small_square', :value => "3" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_skyscraper', :value => "4" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_square', :value => "5" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_medium_rectangle', :value => "6" },
 { :key_sub_type => 'ads', :key_name => 'openx_zone_large_rectangle', :value => "7" }, 
 { :key_sub_type => 'ads', :key_name => 'openx_url_m3_u', :value => (APP_CONFIG['openx_slot_url'] || "http://openx.com/m3_u_address" ) },
 { :key_sub_type => 'ads', :key_name => 'openx_noscript_href', :value => "http://openx.com/ns_href_address" },
 { :key_sub_type => 'ads', :key_name => 'openx_noscript_imgsrc', :value => "http://openx.com/ns_imgsrc_address" },
 { :key_sub_type => 'ads', :key_name => 'google_adsense_slot_name', :value => ( APP_CONFIG['google_adsense_slot_name'] || "default") },
 { :key_sub_type => 'ads', :key_name => 'google_adsense_account_id', :value => (APP_CONFIG['google_adsense_account_id'] || "ca-pub-9975156792632579" ) },
 { :key_sub_type => 'options', :key_name => 'google_search_engine_id', :value => ("your-google-search-engine-id") },
 { :key_sub_type => 'options', :key_name => 'widget_stories_short_max', :value => "3" },
 { :key_sub_type => 'options', :key_name => 'widget_articles_as_blog_max', :value => "1" },
 { :key_sub_type => 'zvents', :key_name => 'zvents_replacement_url', :value => ("www.zvents.com") },
 { :key_sub_type => 'zvents', :key_name => 'zvent_api_key', :value => (APP_CONFIG['zvent_api_key'] || "false" ) },
 { :key_sub_type => 'zvents', :key_name => 'zvent_location', :value => (APP_CONFIG['zvent_location'] || "false" ) },
 { :key_sub_type => 'twitter_standard_favorites', :key_name => 'favorites_account', :value =>"twitter-account", :hint => 'The account name of the Twitter account to show favorites from' }, 
 { :key_sub_type => 'twitter_standard_favorites', :key_name => 'favorites_widget_title', :value =>"Selected tweets from", :hint => 'A title for the favorites widget' }, 
 { :key_sub_type => 'twitter_standard_favorites', :key_name => 'favorites_widget_caption', :value => (APP_CONFIG['site_title'] || "Default Title"), :hint => 'A subject for the favorites widget' }, 
 { :key_sub_type => 'twitter_standard_search', :key_name => 'search', :value =>"search-value", :hint => 'The account name of the Twitter account to show search from' }, 
 { :key_sub_type => 'twitter_standard_search', :key_name => 'search_widget_title', :value =>"Tweets about", :hint => 'A title for the search widget' }, 
 { :key_sub_type => 'twitter_standard_search', :key_name => 'search_widget_caption', :value => (APP_CONFIG['site_topic'] || "Default Topic" ), :hint => 'A subject for the search widget' }, 
 { :key_sub_type => 'twitter_standard_list', :key_name => 'list_account', :value =>"twitter-account", :hint => 'The account name which owns the Twitter list' }, 
 { :key_sub_type => 'twitter_standard_list', :key_name => 'list_name', :value =>"default-list", :hint => 'The hyphenated name of the twitter list' }, 
 { :key_sub_type => 'twitter_standard_list', :key_name => 'list_widget_title', :value => (APP_CONFIG['site_title'] || "Default Title"), :hint => 'The title for the widget' }, 
 { :key_sub_type => 'twitter_standard_list', :key_name => 'list_widget_caption', :value =>"Tweets about #{(APP_CONFIG['site_topic'] || "Default Topic" )}", :hint => 'The caption for the widget' }
]

settings.each do |setting|
  next if Metadata::Setting.find_setting(setting[:key_name], setting[:key_sub_type])
  puts "Creating setting #{setting[:key_name]} -- #{setting[:key_sub_type]}" if debug

  Metadata::Setting.create!({
		:data => {
		  :setting_sub_type_name => setting[:key_sub_type],
		  :setting_name => setting[:key_name], 
		  :setting_value => setting[:value],
		  :setting_hint => (setting[:hint] || "")
		  }
  })
end

activity_scores = [
 { :key_sub_type => 'importance', :key_name => 'karma',  :value => 3, :hint => "Multiple used when calculating karma actions. High setting maximizes impact of quality of posts as judged by other readers" },
 { :key_sub_type => 'importance', :key_name => 'participation',  :value => 1, :hint => "Multiple used when calculating participation actions. Low setting minimizes impact of posting on user scores." },
 { :key_sub_type => 'participation', :key_name => 'story',  :value => 1, :hint => "Points awarded when user creates a story" },
 { :key_sub_type => 'participation', :key_name => 'article',  :value => 1, :hint => "Points awarded when user creates a article" },
 { :key_sub_type => 'participation', :key_name => 'idea',  :value => 1, :hint => "Points awarded when user creates a idea" },
 { :key_sub_type => 'participation', :key_name => 'event',  :value => 1, :hint => "Points awarded when user creates a event" },
 { :key_sub_type => 'participation', :key_name => 'topic',  :value => 1, :hint => "Points awarded when user creates a topic" },
 { :key_sub_type => 'participation', :key_name => 'resource',  :value => 1, :hint => "Points awarded when user creates a resource" },
 { :key_sub_type => 'participation', :key_name => 'question',  :value => 1, :hint => "Points awarded when user creates a question" },
 { :key_sub_type => 'participation', :key_name => 'answer',  :value => 1, :hint => "Points awarded when user creates a answer" },
 { :key_sub_type => 'participation', :key_name => 'comment',  :value => 1, :hint => "Points awarded when user creates a comment" },
 { :key_sub_type => 'participation', :key_name => 'share',  :value => 1, :hint => "Points awarded when user shares another reader\'s item" },
 { :key_sub_type => 'participation', :key_name => 'invite',  :value => 1, :hint => "Points awarded when user invites a friend" },
 { :key_sub_type => 'karma', :key_name => 'item_vote',  :value => 1, :hint => "Points awarded when item created by user is liked" },
 { :key_sub_type => 'karma', :key_name => 'item_comment',  :value => 1, :hint => "Points awarded when item created by user is commented on" },
 { :key_sub_type => 'karma', :key_name => 'item_shared',  :value => 1, :hint => "Points awarded when item created by user is shared or tweeted" },
 { :key_sub_type => 'karma', :key_name => 'invite_accepted',  :value => 1, :hint => "Points awarded when invite from user is accepted" }
]

activity_scores.each do |activity_score|
  next if Metadata::ActivityScore.find_activity_score(activity_score[:key_name], activity_score[:key_sub_type])
  puts "Creating activity_score #{activity_score[:key_name]} -- #{activity_score[:key_sub_type]}" if debug

  Metadata::ActivityScore.create!({
		:data => {
		  :activity_score_sub_type_name => activity_score[:key_sub_type],
		  :activity_score_name => activity_score[:key_name], 
		  :activity_score_value => activity_score[:value],
		  :activity_score_hint => (activity_score[:hint] || "")
		  }
  })
end

ad_layouts = [
 { :key_sub_type => 'ad_layouts', :key_name => 'default', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'stories_index', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'articles_index', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'resources_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'resource_sections_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'ideas_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'idea_boards_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'events_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'forums_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'topics_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'questions_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'users_index', :layout => "Leader_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'stories_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'articles_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'resources_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'ideas_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'resource_sections_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'idea_boards_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'events_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'forums_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'topics_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'questions_item', :layout => "Banner_A" },
 { :key_sub_type => 'ad_layouts', :key_name => 'users_item', :layout => "Banner_A" }
]

ad_layouts.each do |ad_layout|
  next if Metadata::AdLayout.get(ad_layout[:key_name])
  puts "Creating ad layout #{ad_layout[:key_name]} -- #{ad_layout[:layout]}" if debug

  Metadata::AdLayout.create!({
		:data => {
		  :ad_layout_sub_type_name => ad_layout[:key_sub_type],
		  :ad_layout_name => ad_layout[:key_name], 
		  :ad_layout_layout => ad_layout[:layout],
		  :ad_layout_hint => (ad_layout[:hint] || "")
		  }
  })
end

sponsor_zones = [
 { :sponsor_zone_name => 'home', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'stories', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'articles', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'questions', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'ideas', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'forums', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'resources', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" },
 { :sponsor_zone_name => 'events', :sponsor_zone_topic => 'default',  :sponsor_zone_code => "xxxxxxxxx" }
]

sponsor_zones.each do |sponsor_zone|
  next if Metadata::SponsorZone.get(sponsor_zone[:sponsor_zone_name], sponsor_zone[:sponsor_zone_topic])
  puts "Creating sponsor_zone #{sponsor_zone[:sponsor_zone_name]} -- #{sponsor_zone[:sponsor_zone_topic]}" if debug

  Metadata::SponsorZone.create!({
		:data => {
		  :sponsor_zone_name => sponsor_zone[:sponsor_zone_name], 
		  :sponsor_zone_topic => sponsor_zone[:sponsor_zone_topic],
		  :sponsor_zone_code => sponsor_zone[:sponsor_zone_code]
		  }
  })
end


#######################################################################
# View Tree
#######################################################################

#
# View Object Templates
#
view_object_templates = [
  {
  	:name        => "v2_welcome_panel",
  	:pretty_name => "Version 2 Welcome Panel",
  	:template    => "shared/templates/single_col_welcome_panel"
  },
  {
  	:name        => "v2_single_col_list",
  	:pretty_name => "Version 2 Single Column List",
  	:template    => "shared/templates/single_col_list"
  },
  {
  	:name        => "v2_triple_col_large_2",
  	:pretty_name => "Version 2 Triple Column Large Feature With 2 Sub Items",
  	:template    => "shared/templates/triple_col_large_2"
  },
  {
  	:name        => "v2_double_col_feature",
  	:pretty_name => "Version 2 Double Column Feature",
  	:template    => "shared/templates/double_col_feature"
  },
  {
  	:name        => "v2_single_col_user_list",
  	:pretty_name => "Version 2 Single Column User List",
  	:template    => "shared/templates/single_col_user_list"
  },
  {
  	:name        => "v2_single_col_small_list",
  	:pretty_name => "Version 2 Single Column Small List",
  	:template    => "shared/templates/single_col_small_list"
  },
  {
  	:name        => "v2_single_col_gallery_strip",
  	:pretty_name => "Version 2 Single Column Gallery Strip",
  	:template    => "shared/templates/single_col_gallery_strip"
  },
  {
  	:name        => "v2_single_col_item",
  	:pretty_name => "Version 2 Single Column Item",
  	:template    => "shared/templates/single_col_item"
  },
  {
  	:name        => "v2_double_col_item",
  	:pretty_name => "Version 2 Double Column Item",
  	:template    => "shared/templates/double_col_item"
  },
  {
  	:name        => "v2_double_col_item_list",
  	:pretty_name => "Version 2 Double Column Item List",
  	:template    => "shared/templates/double_col_item_list"
  },
  {
  	:name        => "v2_single_col_gallery_big_image",
  	:pretty_name => "Version 2 Single Column Gallery Big Image",
  	:template    => "shared/templates/single_col_gallery_big_image"
  },
  {
  	:name        => "v2_double_col_gallery_strip",
  	:pretty_name => "Version 2 Double Column Gallery Strip",
  	:template    => "shared/templates/double_col_gallery_strip"
  },
  {
  	:name        => "v2_double_col_triple_item",
  	:pretty_name => "Version 2 Double Column Triple Item",
  	:template    => "shared/templates/double_col_triple_item"
  },
  {
  	:name        => "v2_double_col_feature_triple_item",
  	:pretty_name => "Version 2 Double Column Feature With Triple Item",
  	:template    => "shared/templates/double_col_feature_triple_item"
  },
  {
  	:name        => "old_twitter_standard_list",
  	:pretty_name => "Old Twitter Standard List",
  	:template    => "shared/sidebar/twitter_standard_list"
  },
  {
  	:name        => "v2_ad_template",
  	:pretty_name => "Version 2 Ad Template",
  	:template    => "shared/templates/ad_template"
  },
  {
  	:name        => "v2_single_col_custom_widget",
  	:pretty_name => "Version 2 Single Column Custom Widget",
  	:template    => "shared/templates/single_col_custom_widget"
  },
  {
  	:name        => "v2_double_col_custom_widget",
  	:pretty_name => "Version 2 Double Column Custom Widget",
  	:template    => "shared/templates/double_col_custom_widget"
  },
  {
  	:name        => "v2_triple_col_custom_widget",
  	:pretty_name => "Version 2 Triple Column Custom Widget",
  	:template    => "shared/templates/triple_col_custom_widget"
  }
]
view_object_templates.each do |view_object_template|
  puts "Creating View Object Template: #{view_object_template[:name]} (#{view_object_template[:template]})" if debug and ViewObjectTemplate.find_by_name(view_object_template[:name]).nil?
  ViewObjectTemplate.find_or_create_by_name(view_object_template)
end

#
# View Objects
#
view_objects = [
=begin  
  {
  	:name          => "Latest Gallery",
  	:template_name => "v2_single_col_gallery_strip",
  	:settings      => {
  		:klass_name      => "GalleryItem",
  		:locale_title    => "gallery.title",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "active",
          :args        => [8]
        }        
  		]
  	}
  },
=end
  {
  	:name          => "Welcome Panel",
  	:template_name => "v2_welcome_panel",
  	:settings      => {
  		:klass_name      => "User",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		]
  	}
  },
  {
  	:name          => "Newswire",
  	:template_name => "v2_single_col_small_list",
  	:settings      => {
  		:klass_name      => "Newswire",
  		:locale_title    => "newest_newswires_title",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "active"
        },
  		  {
          :method_name => "unpublished"
        },
  		  {
          :method_name => "newest",
          :args        => [5]
        }        
  		]
  	}
  },
  {
  	:name          => "Featured Gallery Single Column Small Strip",
  	:template_name => "v2_single_col_gallery_strip",
  	:settings      => {
  		:klass_name      => "Gallery",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "featured"
        }
  		]
  	}
  },
  {
  	:name          => "Top Gallery Single Column Big Image",
  	:template_name => "v2_single_col_gallery_big_image",
  	:settings      => {
  		:klass_name      => "Gallery",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "top"
        }
  		]
  	}
  },
  {
  	:name          => "Newest Gallery Double Column Small Strip",
  	:template_name => "v2_double_col_gallery_strip",
  	:settings      => {
  		:klass_name      => "Gallery",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "newest"
        }
  		]
  	}
  },
  {
  	:name          => "Recent Users",
  	:template_name => "v2_single_col_user_list",
  	:settings      => {
  		:klass_name      => "User",
  		:locale_title    => "recent_users_without_count",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "active"
        },
  		  {
          :method_name => "members"
        },
  		  {
          :method_name => "recently_active",
          :args        => [21]
        }        
  		]
  	}
  },
  {
  	:name          => "Newest Stories",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => "shared.sidebar.newest_stories.newest_stories_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Stories Double Column Item List",
  	:template_name => "v2_double_col_item_list",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => "shared.sidebar.newest_stories.newest_stories_title",
  		:locale_subtitle => "shared.stories.stories_subtitle",
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest",
          :args        => [4]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Univeral Items Double Column List",
  	:template_name => "v2_double_col_item_list",
  	:settings      => {
  		:klass_name      => "PfeedItem",
  		:locale_title    => "pfeeds.latest.title",
  		:locale_subtitle => "pfeeds.latest.subtitle",
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "newest_items",
          :args        => [4]
        }
  		]
  	}
  },
  {
  	:name          => "Top Stories",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => "shared.sidebar.top_stories.top_stories_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "top_items",
          :args        => [5, false]
        }
  		]
  	}
  },
  {
  	:name          => "Top Story Single Column Item",
  	:template_name => "v2_single_col_item",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => "shared.sidebar.top_stories.top_stories_title",
  		:locale_subtitle => "shared.stories.stories_subtitle",
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "top_items",
          :args        => [5, false]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Story Double Column Item",
  	:template_name => "v2_double_col_item",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => "shared.sidebar.newest_stories.newest_stories_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest",
          :args        => [1]
        }
  		]
  	}
  },
  {
  	:name          => "Top Classifieds",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Classified",
  		:locale_title    => "classifieds.top_classifieds_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
  		    :method_name => "available"
  		  },
  		  {
          :method_name => "top",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Random Question",
  	:template_name => "v2_single_col_item",
  	:settings      => {
  		:klass_name      => "Question",
  		:locale_title    => "questions.random_questions_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "view_object_random_item"
        }
  		]
  	}
  },
  {
  	:name          => "Random Prediction Question",
  	:template_name => "v2_single_col_item",
  	:settings      => {
  		:klass_name      => "PredictionQuestion",
  		:locale_title    => "predictions.random_predictions_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "approved"
        },
  		  {
          :method_name => "currently_open"
        },
        {
          :method_name => "view_object_random_item"
        }
  		]
  	}
  },
  {
  	:name          => "Newest Prediction Questions",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "PredictionQuestion",
  		:locale_title    => "predictions.newest_predictions_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "approved"
        },
  		  {
          :method_name => "currently_open"
        },
  		  {
          :method_name => "newest",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Questions",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Question",
  		:locale_title    => "questions.newest_questions_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Resources",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Resource",
  		:locale_title    => "resources.newest_resources_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Universal Items",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "PfeedItem",
  		:locale_title    => "pfeeds.latest.title",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:css_class       => "active",
  		:kommands        => [
  		  {
  		    :method_name => "newest_items",
          :args        => [5]
  		  }
  		]
  	}
  },
  {
  	:name          => "Top Universal Items",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Vote",
  		:locale_title    => "generic.top_items.title",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:css_class       => "active",
  		:kommands        => [
  		  {
  		    :method_name => "top_items",
          :args        => [5]
  		  }
  		]
  	}
  },
  {
  	:name          => "Triple Item Featured Widget",
  	:template_name => "v2_triple_col_large_2",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		]
  	}
  },
  {
  	:name          => "Newest Classifieds",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Classified",
  		:locale_title    => "classifieds.newest_classifieds_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
  		    :method_name => "available"
  		  },
  		  {
          :method_name => "newest",
          :args        => [5]
        }
  		]
  	}
  },
  {
  	:name          => "Newest Topics",
  	:template_name => "v2_single_col_list",
  	:settings      => {
  		:klass_name      => "Topic",
  		:locale_title    => "forums.newest_topics_title",
  		:locale_subtitle => nil,
  		:use_post_button => true,
  		:kommands        => [
  		  {
          :method_name => "newest"
        }
  		]
  	}
  },
  {
  	:name          => "Newest Articles Feature",
  	:template_name => "v2_double_col_feature",
  	:settings      => {
  		:klass_name      => "Article",
  		:locale_title    => "articles.newest_title",
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "published"
        },
  		  {
          :method_name => "newest",
          :args        => [1]
        }
  		]
  	}
  },
  {
  	:name          => "Old Twitter Standard List",
  	:template_name => "old_twitter_standard_list",
  	:settings      => {
  		:klass_name      => "Content",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:cache_enabled   => false,
      :old_widget      => true,
  		:kommands        => [
  		]
  	}
  },
  {
  	:name          => "Default Ad Small Square",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["small_square", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Default Ad Square",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["square", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Default Ad Medium Rectangle",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["medium_rectangle", "default"]
        }
  		]
  	}
  },  
  {
  	:name          => "Default Ad Large Rectangle",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["large_rectangle", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Default Ad Skyscraper",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["skyscraper", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Default Ad Banner",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["banner", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Default Ad Leaderboard",
  	:template_name => "v2_ad_template",
  	:settings      => {
  		:klass_name      => "Metadata",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "get_ad_slot",
          :args => ["leaderboard", "default"]
        }
  		]
  	}
  },
  {
  	:name          => "Double Column Triple Featured Items",
  	:template_name => "v2_double_col_triple_item",
  	:settings      => {
  		:klass_name      => "ViewObject",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		]
  	}
  },
  {
  	:name          => "Double Column Triple Popular Items",
  	:template_name => "v2_double_col_triple_item",
  	:settings      => {
  		:klass_name      => "Vote",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		  {
          :method_name => "top_items",
          :args => [3, nil, 3]
        }
  		]
  	}
  },
  {
  	:name          => "Double Column Featured With Triple Items",
  	:template_name => "v2_double_col_feature_triple_item",
  	:settings      => {
  		:klass_name      => "ViewObject",
  		:locale_title    => nil,
  		:locale_subtitle => nil,
  		:use_post_button => false,
  		:kommands        => [
  		]
  	}
  }
]
view_objects.each do |view_object_hash|
  next if ViewObject.find_by_name(view_object_hash[:name])
  puts "Creating View Object: #{view_object_hash[:name]}" if debug

  # Build ViewObject and Metadata::ViewObjectSetting
  view_object = ViewObject.new(:name => view_object_hash[:name])
  #view_object.build_setting
  view_object.setting = Metadata::ViewObjectSetting.new

  # Set template
  view_object_template = ViewObjectTemplate.find_by_name(view_object_hash[:template_name])
  raise "Invalid Template Name" unless view_object_template
  view_object.view_object_template = view_object_template

  # Apply settings
  view_object.setting.view_object_name = view_object_hash[:name].parameterize.to_s
  view_object.setting.klass_name       = view_object_hash[:settings][:klass_name]
  view_object.setting.use_post_button  = view_object_hash[:settings][:use_post_button]
  view_object.setting.locale_title     = view_object_hash[:settings][:locale_title] if view_object_hash[:settings][:locale_title]
  view_object.setting.cache_enabled    = view_object_hash[:settings][:cache_enabled] if view_object_hash[:settings][:cache_enabled]
  view_object.setting.old_widget       = view_object_hash[:settings][:old_widget] if view_object_hash[:settings][:old_widget]
  view_object.setting.css_class        = view_object_hash[:settings][:css_class] if view_object_hash[:settings][:css_class]
  view_object.setting.locale_subtitle  = view_object_hash[:settings][:locale_subtitle] if view_object_hash[:settings][:locale_subtitle]
  view_object.setting.dataset          = view_object_hash[:settings][:dataset] if view_object_hash[:settings][:dataset]

  # Add Kommands
  view_object_hash[:settings][:kommands].each do |kommand|
    args = kommand[:args] || []
    view_object.setting.add_kommand(kommand[:method_name], *args)
  end

  # Make sure to save both the view object and the metadata setting
  if view_object.valid? and view_object.setting.valid?
    view_object.save!
    view_object.setting.save!
  else
  	raise (view_object.errors.full_messages | view_object.setting.errors.full_messages).inspect
  end
end

home_view_object = ViewObject.find_or_create_by_name("home--index")
unless home_view_object.edge_children.any?
  ["Newest Univeral Items Double Column List", "Welcome Panel", "Recent Users", "Newest Story Double Column Item", "Newest Gallery Double Column Small Strip", "Newswire"].each do |name|
    puts "Adding #{name}" if debug
    home_view_object.add_child! ViewObject.find_by_name(name)
  end
end
