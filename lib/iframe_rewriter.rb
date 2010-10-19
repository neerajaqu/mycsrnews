# Inspired by [Karma Chameleon](http://gist.github.com/208616)

require "nokogiri"
require "uri"

module Newscloud
  class IframeRewriter

    def initialize(app, flag = "iframe")
      @app = app
      @flag = flag
      @base_url = FACEBOOKER["callback_url"].downcase
    end

    def call(env)
      status, headers, response = @app.call(env)

      if headers["Newscloud-Origin"] and headers["Newscloud-Origin"] == 'iframe'
      	response = add_iframes(response)
      	headers["Content-Length"] = response[0].size.to_s
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
      uri = URI.parse(path)
      if uri.relative?
      	uri.path = "/#{@flag}#{uri.path}"
      elsif uri.host.downcase.include? @base_url
      	uri.path = uri.path.sub(%r((^#{@base_url}/?)), '\1iframe/')
      end
      uri.to_s
    end
  end
end
