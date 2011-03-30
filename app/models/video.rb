class Video < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable
  acts_as_galleryable
  acts_as_async_processable

  belongs_to :user
  belongs_to :videoable, :polymorphic => true
  belongs_to :source

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  validates_format_of :remote_video_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :remote_video_url, :with => /(youtube|vimeo|boston).com/i, :message => "should be a youtube or vimeo url", :allow_blank => true
  validates_format_of :embed_code, :with => /<embed[^>]+src="http(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"/i, :message => "should look like an html embed object block", :allow_blank => true

  after_validation :process_video, :if => lambda {|video| video.dirty? }

  before_save :set_user

  def dirty?
    new_record? or remote_video_url_changed? or remote_video_id_changed? or embed_code_changed?
  end

  def url_video?
    remote_video_url?
  end

  def embed_video?
    embed_src?
  end

  def video_src
    case self.remote_video_type
      when 'youtube'
        "http://www.youtube.com/v/#{self.remote_video_id}"
      when 'vimeo'
        "http://vimeo.com/moogaloop.swf?clip_id=#{self.remote_video_id}&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=1&amp;color=ff0179&amp;fullscreen=1"
      when 'boston'
        "http://www.boston.com/video/?bctid=#{self.remote_video_id}"
      when 'vmixcore'
        self.remote_video_id
      else
      	""
    end
  end

  def youtube_video?
    self.remote_video_type == 'youtube'
  end

  def vimeo_video?
    self.remote_video_type == 'vimeo'
  end

  def process_video
    if embed_code?
    	if embed_code =~ /<embed[^>]+?src="([^"]+)"/i
    		self.embed_src = $1
    		if self.embed_src =~ /youtube.com/i
    			self.remote_video_type = 'youtube'
    			self.remote_video_id = self.parse_youtube_url self.embed_src
    		elsif self.embed_src =~ /vimeo.com/i
    		  self.remote_video_type = 'vimeo'
    			self.remote_video_id = self.parse_vimeo_embed self.embed_src
    		elsif self.embed_src =~ /vmixcore.com/i
    		  self.remote_video_type = 'vmixcore'
    			self.remote_video_id = self.parse_vmixcore_embed self.embed_code
    		elsif self.embed_src =~ /brightcove.com/i
    		  self.remote_video_type = 'brightcove_a'
    			self.remote_video_id = self.parse_brightcove_embed self.embed_code
    		else
    		end
    	else
    	end
    elsif remote_video_url?
      if remote_video_url =~ /youtube.com/i
        self.remote_video_type = 'youtube'
        self.remote_video_id = self.parse_youtube_url remote_video_url
      elsif remote_video_url =~ /vimeo.com/i
        self.remote_video_type = 'vimeo'
        self.remote_video_id = self.parse_vimeo_url remote_video_url       
      elsif Metadata::Setting.find_setting("site_video_url").present?
        if remote_video_url =~ /#{Metadata::Setting.find_setting("site_video_url").value}/i
          self.remote_video_type = 'brightcove_a'
          self.remote_video_id = self.parse_site_url remote_video_url
        else
        end
      else
      end
    else
    end
    # TODO:: switch to async processing
    # Rails.env.production? ? async(:set_video_info!) : set_video_info
    self.set_video_info
  end

  def parse_vimeo_url url
    if url =~ /vimeo.com\/([^"&]+)/
    	self.remote_video_id = $1
    else
    	return false
    end
  end

  def parse_youtube_url url
    if url =~ /youtube.com\/(watch\?v=|v\/)([^"&?]+)/
    	self.remote_video_id = $2
    else
    	return false
    end
  end

  def parse_site_url url
    site_video_url = Metadata::Setting.find_setting("site_video_url").value
    if url =~ /#{site_video_url}\/(video\/\?bctid=|v\/)([^"&]+)/
    	self.remote_video_id = $2
    elsif url =~ /#{site_video_url}\/video\/viral_page\/\?\/services\/player\/bcpid21962023001\&(bctid=|v)([^"&]+)/
    	self.remote_video_id = $2
    else
    	return false
    end
  end
  
  def parse_vimeo_embed src
    if src =~ /vimeo.com\/moogaloop.swf\?clip_id\=([^"&]+)/
    	self.remote_video_id = $1
    else
    	return false
    end
  end

  def parse_brightcove_embed src
    if src =~ /videoId\=([^"&]+)/
    	self.remote_video_id = $1
    else
    	return false
    end
  end

  def parse_vmixcore_embed src
    if src =~ /<embed[^>]+?src="([^"]+?)player_id=.*?"[^>]+?flashvars="([^"]+)"/i
    	movie = $1
    	flash_vars = $2
    	return false unless movie and flash_vars and movie =~ /vmixcore.com/i
    	return movie + flash_vars
    else
    	return false
    end
  end

  def set_user
    unless self.user.present? or self.videoable.nil?
      self.user = self.videoable.user if self.videoable.respond_to? :user
    end
  end

  def get_width size = "normal"
    video_type = Video.sizes[self.remote_video_type].present? ? self.remote_video_type : "default"
    return Video.sizes[video_type][size]["width"]
  end

  def get_height size = "normal"
    video_type = Video.sizes[self.remote_video_type].present? ? self.remote_video_type : "default"
    return Video.sizes[video_type][size]["height"]
  end

  def self.sizes
    {
      "vimeo" => {
        "normal" => {
          "width" => 400,
          "height" => 225
        },
        "large" => {
          "width" => 480,
          "height" => 270          
        }
      },
      "youtube"=> {
        "normal" => {
          "width" => 425,
          "height" => 344
        },
        "large" => {
          "width" => 480,
          "height" => 385          
        }
      },
      "boston"=> {
        "normal" => {
          "width" => 420,
          "height" => 376
        },
        "large" => {
          "width" => 420,
          "height" => 376          
        }
      },
      "default"=> {
        "normal" => {
          "width" => 425,
          "height" => 344
        },
        "large" => {
          "width" => 480,
          "height" => 385          
        }
      }  
    }
  end

  def set_video_info
    return true unless self.title.nil? and self.description.nil?
    if youtube_video?
    	#thumb_url = "http://img.youtube.com/vi/#{remote_video_id}/2.jpg"
    	info = get_youtube_info
    elsif vimeo_video?
      info = get_vimeo_info
    else
    	info = {}
    end
    self.title       = info[:title]
    self.description = info[:description]
    self.thumb_url   = info[:thumb_url]
    self.medium_url  = info[:medium_url]
  end
  def set_video_info!() set_video_info and save end

=begin
  # TODO:: use this or set_video_info!
  def process
    set_video_info
    save
    # update galleryable set_item_info
  end
=end

  def get_vimeo_info
    vimeo_json_url = "http://vimeo.com/api/v2/video/#{remote_video_id}.json"
    info = JSON.parse(open(vimeo_json_url).read).first rescue nil
    return {} if info.nil?
    {
    	:title       => info["title"],
    	:description => info["description"],
    	:thumb_url   => info["thumbnail_medium"],
    	:medium_url  => info["thumbnail_medium"]
    }
  end

  def get_youtube_info
    youtube_json_url = "http://gdata.youtube.com/feeds/api/videos/#{remote_video_id}?v=2&alt=json"
    info = JSON.parse(open(youtube_json_url).read) rescue nil
    return {} if info.nil?
    {
    	:title       => info["entry"]["media$group"]["media$title"]["$t"],
    	:description => info["entry"]["media$group"]["media$description"]["$t"],
    	:thumb_url   => info["entry"]["media$group"]["media$thumbnail"].first["url"],
    	:medium_url  => info["entry"]["media$group"]["media$thumbnail"][1]["url"]
    }
  end

  def thumb_url
    super
  end

  def medium_url
    super
  end

  def full_url
    if self.youtube_video?
    	"http://www.youtube.com/watch?v=#{remote_video_id}"
    else
      self.remote_video_url
    end
  end

  alias_method :featured_title, :item_title
  alias_method :featured_image_url, :thumb_url

  def item_link
    self.videoable or self.galleries.first
  end

  def self.youtube_url? url
    url =~ %r{^https?://(?:www\.)?youtube.com\/(watch\?v=|v\/)([^"&]+)}
  end

  def self.vimeo_url? url
    url =~ %r{^https?://(?:www\.)?vimeo.com/([^"&/]+)}
  end
  
end
