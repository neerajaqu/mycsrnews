class Video < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable

  belongs_to :user
  belongs_to :videoable, :polymorphic => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  validates_format_of :remote_video_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :remote_video_url, :with => /(youtube|vimeo).com/i, :message => "should be a youtube or vimeo url", :allow_blank => true
  validates_format_of :embed_code, :with => /<embed[^>]+src="http(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"/i, :message => "should look like a URL", :allow_blank => true

  after_validation :process_video
  #after_validation :set_user

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
        "http://vimeo.com/v/#{self.remote_video_id}"
      when 'vmixcore'
        self.remote_video_id
      else
      	""
    end
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
    			self.remote_video_id = self.parse_vimeo_url self.embed_src
    		elsif self.embed_src =~ /vmixcore.com/i
    		  self.remote_video_type = 'vmixcore'
    			self.remote_video_id = self.parse_vmixcore_src self.embed_code
    		else
    			return false
    		end
    	else
    		return false
    	end
    elsif remote_video_url?
      if remote_video_url =~ /youtube.com/i
        self.remote_video_type = 'youtube'
        self.remote_video_id = self.parse_youtube_url remote_video_url
      elsif
        self.remote_video_type = 'vimeo'
        self.remote_video_id = self.parse_vimeo_url remote_video_url       
      else
      	return false
      end
    else
    	return false
    end
  end

  def parse_vimeo_url url
    if url =~ /vimeo.com\/([^"&]+)/
    	self.remote_video_id = $1
    else
    	return false
    end
  end

  def parse_youtube_url url
    if url =~ /youtube.com\/(watch\?v=|v\/)([^"&]+)/
    	self.remote_video_id = $2
    else
    	return false
    end
  end

  def parse_vmixcore_src src
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
    self.user = current_user unless self.user.present?
  end

end
