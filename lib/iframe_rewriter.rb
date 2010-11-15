# Inspired by [Karma Chameleon](http://gist.github.com/208616)

require "nokogiri"
require "uri"

module Newscloud
  class IframeRewriter

    def initialize(app, flag = "iframe")
      @app = app
      @flag = flag
      @base_url = FACEBOOKER["callback_url"].downcase.sub(%r(^https?://), '')
    end

    def call(env)
      status, headers, response = @app.call(env)

      if headers['Content-Type'] =~ /html/ and headers["Newscloud-Origin"] and headers["Newscloud-Origin"] == 'iframe'
      	response = add_iframes(response)
      	headers["Content-Length"] = response[0].size.to_s

      	headers["Location"] = add_iframe(headers["Location"]) if headers["Newscloud-Redirect"] and headers["Newscloud-Redirect"] == 'redirect' and headers["Location"]
      end

      [status, headers, response]
    end

    private

    def add_iframes response
      body = ""
      response.each {|chunk| body += chunk}
      doc = Nokogiri::XML(body)

      doc.css("a").each { |link| link["href"] = add_iframe(link["href"]) if link["href"] }
      doc.css("form").each { |form| form["action"] = add_iframe(form["action"]) if form["action"] }

      response = [doc.to_s]
    end

    def add_iframe path
      return path if path =~ /^javascript:/
      uri = URI.parse(path)
      return uri.to_s if uri.path =~ /^\/iframe/
      if uri.relative? or uri.host == @base_url
      	uri.path = "/#{@flag}#{uri.path}"
      end
      uri.to_s
    end
  end
end
