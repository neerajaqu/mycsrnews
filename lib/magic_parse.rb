# MagicParse.rb
#
# MagicParse -- its magically delicious
# Makes crappy feeds taste like marshmallows!

require 'hpricot'
require 'open-uri'

class MagicParse
  class << self
    def title_fields; ['title', 'subtitle', 'link']; end
    def date_fields; ['updated', 'date', 'updated_at', 'pubDate', 'published', 'lastBuildDate', 'dc:date']; end
    def body_fields; ['description', 'content', 'summary', 'caption']; end
    def link_fields; ['link', 'guid']; end
    def image_fields; ['image', 'imageUrl', 'image_url', 'photo' 'logo', 'icon']; end
  end

  def initialize url
    begin
      @doc = open(url) { |f| Hpricot.XML(f) }
    rescue => e
      puts "Failed to open feed at #{feed.url} -- #{e}"
      Rails.logger "ERROR::MagicParse(#{Time.now}) -- failed to open feed at #{feed.url} with error: #{e}"
      return false
    end
      
    @data = {}
  end

  def method_missing(name, *args)
    if name.to_s =~ /(.*)=$/
    	@data[$1] = args.first
    else
    	@data[name] || name.to_s =~ /^get_(.*)$/ ? parse_value($1, nil, true) : parse_value(name)
    end
  end

  def parse_value element, doc = nil, html = false
    element = element.to_s
    doc ||= @doc
    fields = MagicParse.respond_to?("#{element}_fields") ? MagicParse.send("#{element}_fields") : [element]

    search = plural?(element) ? lambda { |doc,ele| (doc/element) } : lambda { |doc,ele| doc.at(ele) }

    result = nil
    fields.each do |field|
      result = search.call(doc, field)
      break if result.present?
    end

    result = (doc/singularize(element)) unless result.present? or singular?(element)

    return (result.present? and html ? (plural?(element) ? result.map { |e| inner_text(e) } : inner_text(result)) : result)
  end

  def get_pub_date; get_date || parse_value('date', items, true); end

  def inner_text item
    if item.children.any? and item.children.first.is_a?(Hpricot::CData)
    	item.children.first.inner_text
    else
    	item.html
    end
  end

  def get_items
    results = []
    items.each do |item|
      results << {
      	:title    => parse_value('title', item, true),
      	:link     => parse_value('link', item, true),
      	:body     => parse_value('body', item, true),
      	:caption  => parse_value('caption', item, true),
      	:date     => parse_value('date', item, true),
      	:image    => parse_pub_images(item)
      }
    end

    results
  end

  def parse_pub_images doc = nil
    images = parse_values 'images', doc, true
    return images if images.present?

    # can't use this.. get_value returns nil for enclosure; technically empty ele with attrs.
    #enclosure = parse_value 'enclosures', doc
    enclosure = doc.at('enclosure')

    if enclosure and enclosure.attributes['type'] =~ %r{^image/(jpeg|jpg|gif|png)$}i
      return enclosure.attributes['url']
    else
      return nil
    end
  end

  private

  def doc; @doc; end

  def items; @items ||= (@doc/"item"); end

  def plural? word; word.to_s.singularize.pluralize == word.to_s; end
  def singular? word; word.to_s.pluralize.singularize == word.to_s; end
  def pluralize word; word.to_s.singularize.pluralize; end
  def singularize word; word.to_s.pluralize.singularize; end
end
