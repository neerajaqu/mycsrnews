require 'hpricot'
require 'net/http'
require 'open-uri'

module Parse
  module Page
    
    def parse_page(url)
      parsed_url = URI.parse(url)
      url = "http://#{url}" unless url =~ %r(^https?://)

      @images_sized = []
      @skip_images = Metadata::SkipImage.all.map(&:image_url)
      @title_filters = Metadata::TitleFilter.all.map(&:keyword)
      page = open(url) { |f| Hpricot(f) }
      results = {}
      results[:title] = self.parse_title(page)
      results[:description] = self.parse_description(page)
      results[:images] = self.parse_images(page, parsed_url)
      results[:images_sized] = @images_sized.sort {|a,b| a[:size] <=> b[:size]}.reverse

      results
    end

    def self.parse_title(doc)
      title = (doc/"head/title").inner_html
      title = @title_filters.inject(title) {|str,key| str.gsub(%r{#{key}}, '') }
      title.sub(/^[|\s]+/,'').sub(/[|\s]+$/,'').gsub(/&nbsp;/,' ')
    end

    def self.parse_description(doc)
      desc = (doc/"head/meta[@name='description']")
      desc = (doc/"head/meta[@http-equiv='Description']") unless desc.present?
      desc = (doc/"head/meta[@http-equiv='description']") unless desc.present?
      return false unless desc.present?
      desc.first.attributes['content']
    end

    def self.parse_images(doc, url)
      images = (doc/"img")
      valid_images = []
      images.each do |image|
        image_url = self.concat_url(url, image.attributes['src'])
        valid_images << image_url if self.is_valid_image? image_url
      end

      valid_images
    end

    def self.is_valid_image?(image_url)
      min_image_size = 3500
      return false if @skip_images.include? image_url
      begin
        url = URI.parse(image_url)
      rescue URI::InvalidURIError
        return false
      end
      response = nil

      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      response = http.request_head(url.path)

      return false unless response and response['content-length'].present?

      size = response['content-length'].to_i
      if size >= min_image_size and not image_url =~ /\.gif(\??.*)?$/
      	@images_sized << {:size => size, :url => image_url}
      	return true
      else
      	return false
      end
    end

    def self.concat_url(parsed_url, path)
      return path if path =~ %r(^https?://)
      base_url = "#{parsed_url.scheme}://#{parsed_url.host}"
      base_url += parsed_url.path unless path =~ %r(^/)
      base_url += path
    end

  module_function :parse_page

  end
end
