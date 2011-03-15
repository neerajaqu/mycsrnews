# THANKS TO:: http://blog.coderubik.com/2011/03/restful-facebook-canvas-app-with-rails-and-post-for-canvas/
# Don't forget to add 'use Rack::Facebook' in config.ru.
module Rack
  class FacebookRequest
    
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Request.new(env)
      
      if request.POST['fb_sig_app_id']
        env["REQUEST_METHOD"] = 'GET'
      end
      
      return @app.call(env)
    end
  
  end
end