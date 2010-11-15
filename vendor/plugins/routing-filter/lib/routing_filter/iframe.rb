require 'routing_filter/base'

module RoutingFilter
  class Iframe < Base
    class << self
      def iframe_pattern
        @@iframe_pattern ||= %r(^/(iframe)(?=/|$))
      end
    end

    def around_recognize(path, env, &block)
      iframe = extract_iframe!(path)
      returning yield do |params|
        params[:iframe] = iframe if iframe
      end
    end

    def around_generate(*args, &block)
      iframe = args.extract_options!.delete(:iframe)

      returning yield do |result|
        # Disabled due to fragment caching
        # Reenabled for ajax hack
        if iframe
          url = result.is_a?(Array) ? result.first : result
          prepend_iframe!(url, iframe)
        end
      end
    end

    protected

      def extract_iframe!(path)
        path.sub! self.class.iframe_pattern, ''
        $1
      end

      def prepend_iframe!(url, iframe)
        # Moved this to a rack middleware due to fragment caching issues
        # Reenabled for ajax hack
        url.sub!(%r(^(http.?://[^/]*)?(.*))) { "#{$1}/#{iframe}#{$2}" }
      end
  end
end
