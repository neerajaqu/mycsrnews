require 'routing_filter/base'
module RoutingFilter
  class Locale < Base
    def around_recognize(path, env, &block)
      locale = nil
      path.sub! %r(^/([a-zA-Z]{2})(?=/|$)) do locale = $1; '' end
      returning yield do |params|
        params[:locale] = locale || 'uk'
      end
    end
    def around_generate(*args, &block)
      locale = args.extract_options!.delete(:locale) || 'uk'
      returning yield do |result|
        if locale != 'uk'
          result.sub!(%r(^(http.?://[^/]*)?(.*))){ "#{$1}/#{locale}#{$2}" }
        end 
      end
    end
  end
end