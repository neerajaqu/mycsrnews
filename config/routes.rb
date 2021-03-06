ActionController::Routing::Routes.draw do |map|
  map.resources :oauth_consumers,:member=>{:callback=>:get}

  # Set locale and make pretty urls
  map.filter 'locale'
  # Determine iframe or web origin of request
  map.filter :iframe

  # Mogli
  map.resource :oauth, :controller=>"oauth"
  map.oauth_callback "/oauth/create", :controller=>"oauth", :action=>"create"

  # TEST DESIGN ROUTE
  map.test_design '/test_design.:format', :controller => 'home', :action => 'test_design'

  map.toggle_blocked '/block.:format', :controller => 'flags', :action => 'block'
  map.toggle_featured '/feature.:format', :controller => 'flags', :action => 'feature'
  map.like_item '/like.:format', :controller => 'votes', :action => 'like'
  map.dislike_item '/dislike.:format', :controller => 'votes', :action => 'dislike'
  map.logout '/logout.:format', :controller => 'sessions', :action => 'destroy'
  map.login '/login.:format', :controller => 'sessions', :action => 'new'
  map.register '/register.:format', :controller => 'users', :action => 'create'
  map.signup '/signup.:format', :controller => 'users', :action => 'new'
  map.account_menu '/account_menu.:format', :controller => 'users', :action => 'account_menu'
  map.faq '/faq.:format', :controller => 'home', :action => 'faq'
  map.about '/about.:format', :controller => 'home', :action => 'about'
  map.terms '/terms.:format', :controller => 'home', :action => 'terms'
  map.test_widgets '/test_widgets.:format', :controller => 'home', :action => 'test_widgets'
  map.contact_us '/contact_us.:format', :controller => 'home', :action => 'contact_us'
  map.app_tab '/app_tab.:format', :controller => 'home', :action => 'app_tab'
  map.external_page '/external_page.:format', :controller => 'home', :action => 'external_page'

  map.feed_newswires '/newswires/feed/:feed_id.:format', :controller => 'newswires', :action => 'feed_index'
  map.paged_articles '/articles/page/:page.:format', :controller => 'articles', :action => 'index'
  map.user_articles '/articles/user/:user_id.:format', :controller => 'articles', :action => 'user_index'

#
# PAGINATION
#
  map.paged_articles_with_format '/articles/page/:page.:format', :controller => 'articles', :action => 'index'
  map.paged_classifieds '/classifieds/page/:page.:format', :controller => 'classifieds', :action => 'index'
  map.paged_classifieds_with_format '/classifieds/page/:page.:format', :controller => 'classifieds', :action => 'index'
  map.paged_events '/events/page/:page.:format', :controller => 'events', :action => 'index'
  map.paged_feed_newswires '/newswires/feed/:feed_id/page/:page.:format', :controller => 'newswires', :action => 'feed_index'
  map.paged_forums '/forums/:id/page/:page.:format', :controller => 'forums', :action => 'show'
  map.paged_forums_with_format '/forums/:id/page/:page.:format', :controller => 'forums', :action => 'show'
  map.paged_galleries '/galleries/page/:page.:format', :controller => 'galleries', :action => 'index'
  map.paged_galleries_with_format '/galleries/page/:page.:format', :controller => 'galleries', :action => 'index'
  map.paged_ideas '/ideas/page/:page.:format', :controller => 'ideas', :action => 'index'
  map.paged_idea_boards '/idea_boards/:id/page/:page.:format', :controller => 'idea_boards', :action => 'show'
  map.paged_idea_boards_with_format '/idea_boards/:id/page/:page.:format', :controller => 'idea_boards', :action => 'show'
  map.paged_my_events '/events/:id/my_events/page/:page.:format', :controller => 'events', :action => 'my_events'
  map.paged_my_questions '/questions/:id/my_questions/page/:page.:format', :controller => 'questions', :action => 'my_questions'
  map.paged_my_resources '/resources/:id/my_resources/page/:page.:format', :controller => 'resources', :action => 'my_resources'
  map.paged_newswires '/newswires/page/:page.:format', :controller => 'newswires', :action => 'index'
  map.paged_prediction_groups '/prediction_groups/page/:page.:format', :controller => 'prediction_groups', :action => 'index'
  map.paged_questions '/questions/page/:page.:format', :controller => 'questions', :action => 'index'
  map.paged_resources '/resources/page/:page.:format', :controller => 'resources', :action => 'index'
  map.paged_stories '/stories/page/:page.:format', :controller => 'stories', :action => 'index'
  map.paged_stories_with_format '/stories/page/:page.:format', :controller => 'stories', :action => 'index'
  map.paged_user_articles '/articles/user/:user_id/page/:page.:format', :controller => 'articles', :action => 'user_index'
  map.paged_users '/users/:id/page/:page.:format', :controller => 'users', :action => 'show'
  map.paged_users_with_format '/users/:id/page/:page.:format', :controller => 'users', :action => 'show'
#
# TAGS
#
  map.tagged_articles '/articles/tag/:tag.:format', :controller => 'articles', :action => 'tags'
  map.tagged_articles_with_page '/articles/tag/:tag/page/:page.:format', :controller => 'articles', :action => 'tags'
  map.tagged_classifieds '/classifieds/tag/:tag.:format', :controller => 'classifieds', :action => 'tags'
  map.tagged_classifieds_with_page '/classifieds/tag/:tag/page/:page.:format', :controller => 'classifieds', :action => 'tags'
  map.tagged_contents '/stories/tag/:tag.:format', :controller => 'stories', :action => 'tags'
  map.tagged_contents_with_page '/stories/tag/:tag/page/:page.:format', :controller => 'stories', :action => 'tags'
  map.tagged_events '/events/tag/:tag.:format', :controller => 'events', :action => 'tags'
  map.tagged_events_with_page '/events/tag/:tag/page/:page.:format', :controller => 'events', :action => 'tags'
  map.tagged_forum '/forums/:forum_id/tag/:tag.:format', :controller => 'topics', :action => 'tags'
  map.tagged_forum_with_page '/forums/:forum_id/tag/:tag/page/:page.:format', :controller => 'topics', :action => 'tags'
  map.tagged_galleries '/galleries/tag/:tag.:format', :controller => 'galleries', :action => 'tags'
  map.tagged_galleries_with_page '/galleries/tag/:tag/page/:page.:format', :controller => 'galleries', :action => 'tags'
  map.tagged_ideas '/ideas/tag/:tag.:format', :controller => 'ideas', :action => 'tags'
  map.tagged_ideas_with_page '/ideas/tag/:tag/page/:page.:format', :controller => 'ideas', :action => 'tags'
  map.tagged_prediction_groups '/prediction_groups/tag/:tag.:format', :controller => 'prediction_groups', :action => 'tags'
  map.tagged_prediction_groups_with_page '/prediction_groups/tag/:tag/page/:page.:format', :controller => 'prediction_groups', :action => 'tags'
  map.tagged_prediction_questions '/prediction_questions/tag/:tag.:format', :controller => 'prediction_questions', :action => 'tags'
  map.tagged_prediction_questions_with_page '/prediction_questions/tag/:tag/page/:page.:format', :controller => 'prediction_questions', :action => 'tags'
  map.tagged_questions '/questions/tag/:tag.:format', :controller => 'questions', :action => 'tags'
  map.tagged_questions_with_page '/questions/tag/:tag/page/:page.:format', :controller => 'questions', :action => 'tags'
  map.tagged_resources '/resources/tag/:tag.:format', :controller => 'resources', :action => 'tags'
  map.tagged_resources_with_page '/resources/tag/:tag/page/:page.:format', :controller => 'resources', :action => 'tags'
  map.tagged_stories '/stories/tag/:tag.:format', :controller => 'stories', :action => 'tags'
  map.tagged_stories_with_page '/stories/tag/:tag/page/:page.:format', :controller => 'stories', :action => 'tags'

  map.idea_tag_with_page '/ideas/tag/:tag/page/:page.:format', :controller => 'ideas', :action => 'tags'
  map.idea_tag '/ideas/tag/:tag.:format', :controller => 'ideas', :action => 'tags'
  map.resource_tag_with_page '/resources/tag/:tag/page/:page.:format', :controller => 'resources', :action => 'tags'
  map.resource_tag '/resources/tag/:tag.:format', :controller => 'resources', :action => 'tags'
  map.event_tag_with_page '/events/tag/:tag/page/:page.:format', :controller => 'events', :action => 'tags'
  map.event_tag '/events/tag/:tag.:format', :controller => 'events', :action => 'tags'
  map.prediction_group_tag_with_page '/prediction_groups/tag/:tag/page/:page.:format', :controller => 'prediction_groups', :action => 'tags'
  map.prediction_group_tag '/prediction_groups/tag/:tag.:format', :controller => 'prediction_groups', :action => 'tags'
  map.prediction_question_tag_with_page '/prediction_questions/tag/:tag/page/:page.:format', :controller => 'prediction_questions', :action => 'tags'
  map.prediction_question_tag '/prediction_questions/tag/:tag.:format', :controller => 'prediction_questions', :action => 'tags'

  map.top_users '/users/top/:top.:format', :controller => 'users', :action => 'index'
  map.set_status_classified '/classifieds/:id/set_status/:status.:format', :controller => 'classifieds', :action => 'set_status'
#
#
# Categories
#
  map.categorized_classifieds '/classifieds/category/:category.:format', :controller => 'classifieds', :action => 'categories'
  map.categorized_classifieds_with_page '/classifieds/category/:category/page/:page.:format', :controller => 'classifieds', :action => 'categories'


#
# RESOURCES
#
  #map.prediction_question '/prediction_question/:id.:format', :controller => 'predictions', :action => 'show_question'
  #map.resources :prediction_guesses, :collection => { :create => [ :post] }
  map.resources :amazon_products, :collection => { :search => [:get, :post] }
  map.resource :session
  map.resources :answers, :member => { :like => [:get, :post] }, :has_many => [:comments, :answers, :flags]
  map.resources :articles, :collection => { :index => [:get, :post], :drafts => [:get] }
  map.resources :cards, :member => { :get_card_form => [:get, :post], :post_sent => [:get, :post] }, :collection => { :my_received => :get, :my_sent => :get }
  map.resources :classifieds, :collection => [:borrowed_items, :my_items], :has_many => [:comments, :flags, :related_items]
  map.resources :comments, :member => { :like => [:get, :post],:dislike => [:get, :post] }, :has_many => [ :flags]
  map.resources :contents, :controller => 'stories', :has_many => [:comments, :flags, :related_items], :as => 'stories'
  map.resources :events, :member => { :like => [:get, :post],:my_events => [:get, :post] }, :collection => { :index => [:get, :post], :import_facebook => [:get, :post] },:has_many => [:comments, :flags, :related_items]
  map.resources :forums, :has_many => [:topics]
  map.resources :galleries, :has_many => [:comments, :flags, :related_items], :member => { :add_gallery_item => [:get, :post] }
  map.resources :go, :only => :show
  map.resources :home, :collection => { :preview_widgets => :get, :index => [:get, :post], :app_tab => [:get, :post], :google_ads => [:get],:openx_ads => [:get],:helios_ads => [:get],:helios_alt2_ads => [:get],:helios_alt3_ads => [:get],:helios_alt4_ads => [:get], :about => :get, :faq => :get, :terms => :get, :contact_us => [:get, :post] }, :member => { :render_widget => [:get, :post] }
  map.resources :idea_boards, :has_many => :ideas
  map.resources :ideas, :member => { :like => [:get, :post],:my_ideas => [:get, :post] },:collection => { :index => [:get, :post] }, :has_many => [:comments, :flags, :related_items ]
  map.resources :newswires, :member => { :quick_post => [:get, :post] }
  map.resources :prediction_groups, :member => { :like => [:get, :post] } , :collection => { :index => [:get, :post], :play => [:get, :post] }, :has_many => [:comments, :prediction_questions, :flags]
  map.resources :prediction_questions, :member => { :like => [:get, :post] } , :collection => { :index => [:get, :post] }, :has_many => [ :prediction_guesses, :prediction_results ]
  map.resources :predictions, :collection => { :index => [:get, :post],  :my_predictions => [:get, :post], :scores => [:get, :post] }
  map.resources :questions, :member => { :like => [:get, :post], :create_answer => :post, :my_questions => [:get, :post] }, :collection => { :index => [:get, :post] }, :has_many => [:comments, :answers, :flags]
  map.resources :related_items
  map.resources :resource_sections, :has_many => :resources
  map.resources :resources, :member => { :like => [:get, :post], :my_resources => [:get, :post] }, :collection => { :index => [:get, :post] }, :has_many => [:comments, :flags, :related_items]
  map.resources :stories, :member => { :like => [:get, :post] },:collection => { :parse_page => [:get, :post], :index => [:get, :post] }, :has_many => :comments
  map.resources :topics, :has_many => [:comments]
  map.resources :users, :collection => {:link_user_accounts => :get, :feed => [:get], :invite => [:get, :post], :current => [:get, :post], :update_bio => [:get,:post], :dont_ask_me_invite_friends => :get, :dont_ask_me_for_email => :get }
  map.resources :view_objects, :collection => { :test => :get }
  map.resources :widgets, :collection => { :newswires => [:get], :questions => [:get], :forum_roll => [:get], :topics => [:get], :blog_roll => [:get], :blogger_profiles => [:get], :fan_application => [:get], :add_bookmark => [:get], :user_articles => [:get], :articles => [:get], :stories => [:get], :activities => [:get]  }, :layout => 'widgets'
  
  map.received_card '/cards/received/:card_id/from/:user_id.:format', :controller => 'cards', :action => 'received'
  map.root :controller => "home", :action => "index"

#
# ADMIN
#
  map.admin 'admin', :controller => :admin, :action => :index
  map.namespace(:admin) do |admin|
    admin.block '/block.:format', :controller => 'misc', :action => 'block'
    admin.flag_item '/flag_item.:format', :controller => 'misc', :action => 'flag'
    admin.feature '/feature.:format', :controller => 'misc', :action => 'feature'
    admin.paged_items '/featured_items/:id/load_items/page/:page', :controller => 'featured_items', :action => 'load_items'
    admin.translations '/translations.:format', :controller => 'translations', :action => 'translations'
    admin.asset_translations '/asset_translations.:format', :controller => 'translations', :action => 'asset_translations'

    admin.resources :activity_scores
    admin.resources :ad_layouts
    admin.resources :ads
    admin.resources :announcements
    admin.resources :answers    
    admin.resources :cards
    admin.resources :classifieds
    admin.resources :comments
    admin.resources :content_dashboard, :collection => { :news_topics => [:get, :post, :put] }
    admin.resources :content_images
    admin.resources :contents
    admin.resources :dashboard_messages, :member => { :send_global => [:get, :post], :clear_global => [:get, :post] }, :collection => { :clear_global => [:get, :post] }
    admin.resources :events, :collection => { :import_zvents => [:get, :post]}
    admin.resources :featured_items, :member => { :load_template => [:get, :post], :load_new_template => [:get, :post], :load_items => [:get, :post] }, :collection => { :save => :post, :new_featured_widgets => :get, :save_featured_widgets => :post }
    admin.resources :feeds, :member => { :fetch_new => :get }
    admin.resources :flags
    admin.resources :forums, :collection => { :reorder => [:get, :post] }
    admin.resources :galleries
    admin.resources :gos
    admin.resources :idea_boards
    admin.resources :ideas
    admin.resources :images
    admin.resources :locales, :collection => { :refresh => [:get] }, :has_many => :translations
    admin.resources :newswires
    admin.resources :prediction_groups, :member => { :approve => [:get, :post] }
    admin.resources :prediction_guesses
    admin.resources :prediction_questions, :member => { :approve => [:get, :post] }
    admin.resources :prediction_results, :member => { :accept => [:get, :post] }
    admin.resources :prediction_scores, :collection => { :refresh_all => [:get, :post ] }
    admin.resources :questions
    admin.resources :related_items
    admin.resources :resource_sections
    admin.resources :resources
    admin.resources :settings
    admin.resources :setting_groups
    admin.resources :skip_images
    admin.resources :sources
    admin.resources :sponsor_zones
    admin.resources :title_filters
    admin.resources :topics
    admin.resources :twitter_settings, :collection => { :update_keys => :post, :update_auth => :post, :reset_keys => :get }
    admin.resources :user_profiles,      :active_scaffold => true
    admin.resources :users,           :active_scaffold => true
    admin.resources :view_objects
    admin.resources :view_object_templates
    admin.resources :votes,           :active_scaffold => true
    admin.resources :widgets, :collection => { :save => :post, :new_widgets => :get, :newer_widgets => :get, :save_newer_widgets => :post }

    admin.namespace(:metadata) do |metadata|
      metadata.resources :activity_scores
      metadata.resources :ad_layouts
      metadata.resources :ads
      metadata.resources :custom_widgets
      metadata.resources :settings
      metadata.resources :skip_images
      metadata.resources :sponsor_zones
      metadata.resources :title_filters
    end
  end

	map.mobile_home '/m', :controller => 'mobile/home', :action => :index
  # use /m/ externally, /mobile/ internally
	map.with_options({:path_prefix => "m", :name_prefix => "mobile_", :namespace => "mobile/"}) do |mobile|
	  mobile.resources :stories
	  mobile.resources :comments
	end

  map.overlay_tweet '/overlays/tweet', :controller => 'overlays', :action => 'tweet'
  # Admin interface

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
