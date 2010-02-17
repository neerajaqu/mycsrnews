class Video < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable

  belongs_to :user
  belongs_to :videoable, :polymorphic => true
  validates_presence_of :remote_video_url, :unless => :embed_code?
  validates_presence_of :embed_code?, :unless => :remote_video_url?

  validates_format_of :remote_video_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :remote_video_url, :with => /(youtube|vimeo).com/i, :message => "should be a youtube or video url", :allow_blank => true
  validates_format_of :embed_code, :with => /<embed[^>]+src="http(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?"/i, :message => "should look like a URL", :allow_blank => true

  after_validation :process_video

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
      else
      	""
    end
  end

  #private

  def process_video
    if embed_code?
    	if embed_code =~ /<embed[^>]+?src="([^"]+)"/i
    		self.embed_src = $1
    		if self.embed_src =~ /youtube.com/i
    			self.remote_video_type = 'youtube'
    			self.remote_video_id = self.parse_youtube_url self.embed_src
    		elsif self.embed_src =~ /vimeo.com/i
    		  self.remote_video_type = 'vimeo'
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
      else
      	return false
      end
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

  def parse_vimeo_url url
  end

end
