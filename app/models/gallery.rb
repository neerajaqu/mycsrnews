class Gallery < ActiveRecord::Base

  acts_as_media_item
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_moderatable
  acts_as_wall_postable
  acts_as_tweetable
  acts_as_relatable
  acts_as_scorable
  acts_as_featured_item

  belongs_to :user
  has_many :comments, :as => :commentable  
  has_many :gallery_items
  has_many :voices, :through => :gallery_items, :source => :user

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :top, lambda { |*args| { :order => ["votes_tally desc, created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["featured_at desc"], :limit => (args.first || 3)} }

  validates_presence_of :user
  validates_presence_of :title, :description
  validates_format_of :tag_list, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."  


  has_friendly_id :title, :use_slug => true

  accepts_nested_attributes_for :gallery_items

  def thumb_url
    return nil unless gallery_items.any?
    gallery_items.first.thumb_url
  end
  alias_method :featured_image_url, :thumb_url

  def medium_url
    return nil unless gallery_items.any?
    gallery_items.first.medium_url
  end

  def full_url
    return nil unless gallery_items.any?
    gallery_items.first.full_url
  end

  def expire
    self.class.sweeper.expire_gallery_all self
  end

  def self.expire_all
    self.sweeper.expire_gallery_all self.new
  end

  def self.sweeper
    GallerySweeper
  end

  def user_voices
    [self.user, self.voices].flatten.uniq
  end

  def self.build_from_youtube_playlist playlist, user = nil
    if playlist =~ %r{^https?://(?:www\.)?youtube.com\/view_play_list\?p=([^"&]+)}
      playlist_id = $1
    elsif playlist =~ /^([a-zA-Z0-9]+)$/
      playlist_id = $1
    else
    	playlist_id = nil
    end
    if playlist_id
      playlist_url = "http://gdata.youtube.com/feeds/api/playlists/#{playlist_id}?alt=json"
      data = JSON.parse(open(playlist_url).read) rescue nil
      return nil unless data

      gallery = Gallery.new
      gallery.user = user || User.admins.first
      gallery.title = data["feed"]["title"]["$t"]
      gallery.description = data["feed"]["subtitle"]["$t"]
      data["feed"]["entry"].each do |entry|
        url = entry["media$group"]["media$content"].first["url"]
        gallery.gallery_items.build(:item_url => url, :gallery => gallery)
      end
      if gallery.save
      	gallery
      else
      	nil
      end
    else
    	return nil
    end
  end

  def set_user user
    self.user = user
    self.gallery_items.map {|gi| gi.user ||= user }
  end

end
