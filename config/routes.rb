ActionController::Routing::Routes.draw do |map|
  # Set locale and make pretty urls
  map.filter 'locale'

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
  map.resources :users, :collection => {:link_user_accounts => :get, :invite => [:get, :post], :current => [:get, :post], :update_bio => [:get,:post] }

  map.resource :session
  map.resources :home, :collection => { :index => [:get, :post], :app_tab => [:get, :post], :google_ads => [:get],:helios_ads => [:get],:helios_alt2_ads => [:get],:helios_alt3_ads => [:get], :bookmarklet_panel => [:get], :about => :get, :faq => :get, :terms => :get, :contact_us => [:get, :post] }, :member => { :render_widget => [:get, :post] }

  map.paged_stories_with_format '/stories/page/:page.:format', :controller => 'stories', :action => 'index'
  map.paged_stories '/stories/page/:page.:format', :controller => 'stories', :action => 'index'
  map.paged_articles_with_format '/articles/page/:page.:format', :controller => 'articles', :action => 'index'
  map.paged_articles '/articles/page/:page.:format', :controller => 'articles', :action => 'index'
  map.paged_ideas '/ideas/page/:page.:format', :controller => 'ideas', :action => 'index'
  map.paged_newswires '/newswires/page/:page.:format', :controller => 'newswires', :action => 'index'
  map.paged_my_events '/events/:id/my_events/page/:page.:format', :controller => 'events', :action => 'my_events'
  map.paged_events '/events/page/:page.:format', :controller => 'events', :action => 'index'
  map.paged_my_resources '/resources/:id/my_resources/page/:page.:format', :controller => 'resources', :action => 'my_resources'
  map.paged_resources '/resources/page/:page.:format', :controller => 'resources', :action => 'index'
  map.paged_questions '/questions/page/:page.:format', :controller => 'questions', :action => 'index'
  map.paged_my_questions '/questions/:id/my_questions/page/:page.:format', :controller => 'questions', :action => 'my_questions'
  map.tagged_stories_with_page '/stories/tag/:tag/page/:page.:format', :controller => 'stories', :action => 'tags'
  map.tagged_stories '/stories/tag/:tag.:format', :controller => 'stories', :action => 'tags'
  map.idea_tag_with_page '/ideas/tag/:tag/page/:page.:format', :controller => 'ideas', :action => 'tags'
  map.idea_tag '/ideas/tag/:tag.:format', :controller => 'ideas', :action => 'tags'
  map.resource_tag_with_page '/resources/tag/:tag/page/:page.:format', :controller => 'resources', :action => 'tags'
  map.resource_tag '/resources/tag/:tag.:format', :controller => 'resources', :action => 'tags'
  map.event_tag_with_page '/events/tag/:tag/page/:page.:format', :controller => 'events', :action => 'tags'
  map.event_tag '/events/tag/:tag.:format', :controller => 'events', :action => 'tags'
  map.resources :stories, :member => { :like => [:get, :post] },:collection => { :parse_page => [:get, :post], :index => [:get, :post] }, :has_many => :comments
  map.resources :contents, :controller => 'stories', :has_many => [:comments, :flags], :as => 'stories'
  map.resources :comments, :member => { :like => [:get, :post],:dislike => [:get, :post] },:has_many => [ :flags]

  map.resources :articles, :collection => { :index => [:get, :post] }
  map.resources :newswires, :member => { :quick_post => [:get, :post] }
  map.resources :ideas, :member => { :like => [:get, :post],:my_ideas => [:get, :post] },:collection => { :index => [:get, :post] }, :has_many => [:comments, :flags]
  map.resources :idea_boards, :has_many => :ideas
  map.resources :resources, :member => { :like => [:get, :post], :my_resources => [:get, :post] }, :collection => { :index => [:get, :post] }, :has_many => [:comments, :flags]
  map.resources :resource_sections, :has_many => :resources
  map.resources :events, :member => { :like => [:get, :post],:my_events => [:get, :post] }, :collection => { :index => [:get, :post], :import_facebook => [:get, :post] },:has_many => [:comments, :flags]
  map.resources :questions, :member => { :like => [:get, :post], :create_answer => :post, :my_questions => [:get, :post] }, :collection => { :index => [:get, :post] }, :has_many => [:comments, :answers, :flags]
  map.resources :answers, :member => { :like => [:get, :post] }, :has_many => [:comments, :answers, :flags]
  map.received_card '/cards/received/:card_id/from/:user_id.:format', :controller => 'cards', :action => 'received'
  map.resources :cards, :member => { :get_card_form => [:get, :post], :post_sent => [:get, :post] }, :collection => { :my_received => :get, :my_sent => :get }

  map.root :controller => "home", :action => "index"
  map.admin 'admin', :controller => :admin, :action => :index
  map.namespace(:admin) do |admin|
    admin.block '/block.:format', :controller => 'misc', :action => 'block'
    admin.flag_item '/flag_item.:format', :controller => 'misc', :action => 'flag'
    admin.feature '/feature.:format', :controller => 'misc', :action => 'feature'
    admin.paged_items '/featured_items/:id/load_items/page/:page', :controller => 'featured_items', :action => 'load_items'
    admin.resources :locales, :collection => { :refresh => [:get] }, :has_many => :translations
    admin.translations '/translations.:format', :controller => 'translations', :action => 'translations'
    admin.asset_translations '/asset_translations.:format', :controller => 'translations', :action => 'asset_translations'
    admin.resources :widgets, :collection => { :save => :post }
    admin.resources :custom_widgets
    admin.resources :metadatas, :controller => 'custom_widgets'
    admin.resources :settings
    admin.resources :ideas
    admin.resources :idea_boards
    admin.resources :resources
    admin.resources :resource_sections
    admin.resources :events
    admin.resources :flags
    admin.resources :questions
    admin.resources :answers    
    admin.resources :featured_items, :member => { :load_template => [:get, :post], :load_items => [:get, :post] }, :collection => { :save => :post }
    admin.resources :contents
    admin.resources :content_images
    admin.resources :newswires
    admin.resources :feeds
    admin.resources :announcements
    admin.resources :dashboard_messages
    admin.resources :comments
    admin.resources :users,           :active_scaffold => true
    admin.resources :user_profiles,      :active_scaffold => true
    admin.resources :votes,           :active_scaffold => true
  end

	map.mobile_home '/m', :controller => 'mobile/home', :action => :index
  # use /m/ externally, /mobile/ internally
	map.with_options({:path_prefix => "m", :name_prefix => "mobile_", :namespace => "mobile/"}) do |mobile|
	  mobile.resources :stories
	  mobile.resources :comments
	end

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
