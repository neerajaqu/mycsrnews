require 'rss'


class FeedParser
  class << self; attr_accessor :title_fields, :date_fields, :body_fields, :link_fields, :image_fields; end
  @title_fields  = ['title', 'subtitle', 'link']
  @date_fields   = ['updated', 'date', 'updated_at', 'pubDate', 'published', 'lastBuildDate', 'dc_date']
  @body_fields   = ['description', 'content', 'summary', 'caption']
  @link_fields   = ['link', 'guid']
  @image_fields  = ['image', 'imageUrl', 'image_url', 'logo', 'icon']

  ['title', 'date', 'body', 'link', 'image'].each do |func|
    define_method func do |*args|
      feed, fields, is_atom = *args
      feed      ||= @feed
      fields    ||= FeedParser.send("#{func}_fields")
      atom_feed ||= self.atom_feed?

      get_value feed, fields, atom_feed
    end
  end

  def initialize(url)
    @url = url
    @feed_type = false
    parse
  end
  
  def parse
    @raw_feed = RSS::Parser.parse(@url)
    raise FeedError, "Invalid feed url: #{@url}" if @raw_feed.nil?
    if @raw_feed.respond_to? 'channel'
      @feed_type = 'RSS'
      @feed = @raw_feed.channel
    else
      @feed_type = 'Atom'
      @feed = @raw_feed
    end
  end

  def get_value feed_object, fields, is_atom
    command = fields.select { |field| feed_object.respond_to? field }.first
    return nil unless command.present?

    command = is_atom == true ? (command == 'link' ? [command, 'href'] : [command, 'content']) : command

    begin
      command.inject(feed_object) { |item, cmd| item.send(cmd) }
    rescue NoMethodError
      nil
    end
  end

  def atom_feed?
    @feed_type == 'Atom'
  end

  def rss_feed?
    @feed_type == 'RSS'
  end

  def items
    items = []

    @raw_feed.items.each do |item|
      items << {
      	:title => title(item),
      	:body => body(item),
      	:date => date(item),
      	:link => link(item),
      	:image => image(item),
      }
    end

    items
  end

end
