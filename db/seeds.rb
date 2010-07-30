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
#todo - fix (User.admins.last || nil) - creates fb user as nil, bombs out in fb helper for profilepic
#PredictionGroup.create!({:title => 'Uncategorized', :section => 'uncategorized', :description => 'These questions are uncategorized'}) unless PredictionGroup.find_by_title_and_section('Uncategorized','uncategorized')

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
 { :key_sub_type => 'options', :key_name => 'exclude_articles_from_news',  :value => "false" },
 { :key_sub_type => 'options', :key_name => 'outbrain_enabled',  :value => "false", :hint => "Enable Outbrain(http://outbrain.com) support" },
 { :key_sub_type => 'options', :key_name => 'outbrain_template_name',  :value => "my_template_name", :hint => "Outbrain template name" },
 { :key_sub_type => 'options', :key_name => 'outbrain_account_id',  :value => "1234567890", :hint => "Outbrain account id" },
 { :key_sub_type => 'options', :key_name => 'outbrain_verification_html',  :value => "false", :hint => "Outbrain verification html, copy paste this from Outbrain." },
 { :key_sub_type => 'options', :key_name => 'site_notification_user',  :value => (User.admins.last || nil) },
 { :key_sub_type => 'options', :key_name => 'enable_activity_popups',  :value => "true" },
 { :key_sub_type => 'options', :key_name => 'allow_web_auth',  :value => (APP_CONFIG['allow_web_auth'] || "false" ) },
 { :key_sub_type => 'options', :key_name => 'site_title',  :value => (APP_CONFIG['site_title'] || "Default Site Title" ) },
 { :key_sub_type => 'options', :key_name => 'site_topic', :value => (APP_CONFIG['site_topic'] || "Default Topic" ) },
 { :key_sub_type => 'options', :key_name => 'contact_us',  :value => (APP_CONFIG['contact_us_recipient'] || "admin@email.com,me@email.com,support@email.com" ) },
 { :key_sub_type => 'options', :key_name => 'firstnameonly', :value => (APP_CONFIG['firstnameonly'] || "false" ) },
 { :key_sub_type => 'options', :key_name => 'site_video_url', :value => APP_CONFIG['base_url'].gsub("http://","").gsub("www",""), :hint => "used by some sites with custom video URLs e.g. boston.com"},
 { :key_sub_type => 'options', :key_name => 'predictions_max_daily_guesses', :value => 25, :hint => "maximum number of guesses allowed per day"},
 { :key_sub_type => 'design', :key_name => 'typekit', :value => (APP_CONFIG['typekit'] || "000000" ) },
 { :key_sub_type => 'twitter', :key_name => 'account', :value =>(APP_CONFIG['twitter_account'] || "userkey_name" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_key', :value => (APP_CONFIG['twitter_oauth_key'] || "U6qjcn193333331AuA" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_secret', :value => (APP_CONFIG['twitter_oauth_secret'] || "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_consumer_key', :value => (APP_CONFIG['twitter_oauth_key'] || "U6qjcn193333331AuA" ) },
 { :key_sub_type => 'twitter', :key_name => 'oauth_consumer_secret', :value => (APP_CONFIG['twitter_oauth_secret'] || "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw" ) },
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
 { :key_sub_type => 'bitly', :key_name => 'bitly_username', :value =>(APP_CONFIG['bitly_username'] || "username" ) },
 { :key_sub_type => 'bitly', :key_name => 'bitly_api_key', :value =>(APP_CONFIG['bitly_api_key'] || "api_key" ) },
 { :key_sub_type => 'facebook', :key_name => 'app_id', :value => (APP_CONFIG['facebook_application_id'] || "111111111111" ) },
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_layout', :value => "default", :hint => 'e.g. default, thumb, host, banner' },
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_image_url', :value => APP_CONFIG['base_url']+"/images/default/icon-fan-app.gif", :hint => "Full (absolute) URL to image, e.g. #{APP_CONFIG['base_url']}/images/default/icon-fan-app.gif, recommended sizes: thumb 50 x 50 or banner = 300 x 90"},
 { :key_sub_type => 'welcome_panel', :key_name => 'welcome_host', :value => "0", :hint => 'userid of host profile image to use'},
 { :key_sub_type => 'stats', :key_name => 'google_analytics_account_id', :value => (APP_CONFIG['google_analytics_account_id'] || "UF-123456890-7" ) },
 { :key_sub_type => 'stats', :key_name => 'google_analytics_site_id', :value => (APP_CONFIG['google_analytics_site_id'] || "1231232" ) },
 { :key_sub_type => 'sitemap', :key_name => 'google-site-verification', :value => "WS8kMC8-Ds77777777777Xy6QcmRpWAfY" },
 { :key_sub_type => 'sitemap', :key_name => 'yahoo-site-verification', :value => "WS87ds77" },
 { :key_sub_type => 'ads', :key_name => 'platform', :value => (APP_CONFIG['ad_platform'] || "google" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_sitepage', :value => (APP_CONFIG['helios_sitepage'] || "youraddomain.com/yourfacebookproject.htm" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_url', :value => (APP_CONFIG['helios_url'] || "http://subdomain.xxx.com" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_script_url', :value => (APP_CONFIG['helios_script_url'] || "http://scriptsubdomain.xxx.com" ) },
 { :key_sub_type => 'ads', :key_name => 'helios_list_pos', :value => (APP_CONFIG['helios_list_pos'] || "728x90_1,468x60_1,300x250_1,160x600_1,250x250_1,200x200_1,336x280_1" ) },
 { :key_sub_type => 'ads', :key_name => 'google_adsense_account_id', :value => (APP_CONFIG['google_adsense_account_id'] || "ca-pub-9975156792632579" ) },
 { :key_sub_type => 'ads', :key_name => 'google_adsense_slot_name', :value => (APP_CONFIG['google_adsense_slot_name'] || "Needle_Small") }
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