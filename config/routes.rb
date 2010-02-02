ActionController::Routing::Routes.draw do |map|
  # Set locale and make pretty urls
  map.filter 'locale'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.faq '/faq', :controller => 'home', :action => 'faq'
  map.about '/about', :controller => 'home', :action => 'about'
  map.terms '/terms', :controller => 'home', :action => 'terms'
  map.test_widgets '/test_widgets', :controller => 'home', :action => 'test_widgets'
  map.contact_us '/contact_us', :controller => 'home', :action => 'contact_us'
  map.app_tab '/app_tab.:format', :controller => 'home', :action => 'app_tab'
  map.resources :users, :collection => {:link_user_accounts => :get, :invite => [:get, :post]}

  map.resource :session
  map.resources :home, :collection => { :app_tab => [:get, :post], :google_ads => [:get], :about => :get, :faq => :get, :terms => :get, :contact_us => [:get, :post] }, :member => { :render_widget => [:get, :post] }

  map.paged_stories_with_format '/stories/page/:page.:format', :controller => 'stories', :action => 'index'
  map.paged_stories '/stories/page/:page', :controller => 'stories', :action => 'index'
  map.tagged_stories_with_page '/stories/tag/:tag/page/:page.:format', :controller => 'stories', :action => 'tags'
  map.tagged_stories '/stories/tag/:tag.:format', :controller => 'stories', :action => 'tags'
  map.resources :stories, :member => { :like => [:get, :post] }, :collection => { :parse_page => [:get, :post] }, :has_many => :comments
  map.resources :contents, :controller => 'stories', :has_many => :comments, :as => 'stories'

  map.resources :articles
  map.resources :newswires, :member => { :publish => [:get, :post] }
  map.resources :ideas, :member => { :like => [:get, :post], :commented => [:get, :post], :my_ideas => [:get, :post] }
  map.resources :idea_boards, :has_many => :ideas
  map.resources :resources, :member => { :like => [:get, :post], :commented => [:get, :post], :my_resources => [:get, :post] }

  map.root :controller => "home", :action => "index"
  map.admin 'admin', :controller => :admin, :action => :index
  map.namespace(:admin) do |admin|
    admin.paged_items '/featured_items/:id/load_items/page/:page', :controller => 'featured_items', :action => 'load_items'
    admin.resources :ideas
    admin.resources :widgets, :collection => { :save => :post }
    admin.resources :idea_boards
    admin.resources :featured_items, :member => { :load_template => [:get, :post], :load_items => [:get, :post] }, :collection => { :save => :post }
    admin.resources :contents,        :active_scaffold => true
    admin.resources :content_images,  :active_scaffold => true
    admin.resources :comments,        :active_scaffold => true
    admin.resources :users,           :active_scaffold => true
    admin.resources :user_infos,      :active_scaffold => true
    admin.resources :votes,           :active_scaffold => true
    admin.resources :feeds,           :active_scaffold => true
    admin.resources :newswires,       :active_scaffold => true
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
