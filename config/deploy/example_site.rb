role :web,  "my.site.com"
role :app,  "my.site.com"
role :db,   "my.site.com", :primary => true
set :rails_env, "production"
set :application, "example_site"
set :user, 'deploy'
