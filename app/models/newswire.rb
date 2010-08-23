class Newswire < ActiveRecord::Base

  belongs_to :feed
  belongs_to :user
  has_one :content

  named_scope :unpublished, { :conditions => ["published = ?", false] }
  named_scope :newest, lambda { |*args| {  :conditions => ["created_at <= ?", Time.zone.now ], :order => ["created_at desc"], :limit => (args.first || 7)} }

  def quick_post user_id = nil, override_image = false
    user_id ||= self.feed.user_id
    return false unless user_id and user_id > 0

    caption = CGI.unescapeHTML self.caption
    begin
      caption = ActionController::Base.helpers.strip_tags(caption)
    rescue
      begin
        caption = HTML::FullSanitizer.new.sanitize(caption)
      rescue
      end
    end
    story_type = self.feed.full_html? ? 'full_html' : 'story'
    @content = Content.new({
    	:title      => self.title,
    	:caption    => caption,
    	:url        => self.url,
    	#:source     => self.feed.title,
    	:user_id    => user_id,
    	:newswire   => self,
    	:story_type => story_type
    })

    if self.imageUrl.present?
    	@content.images.build({ :remote_image_url => self.imageUrl})
    	@content.images.first.override_image = true if override_image
    else
    	page = Parse::Page.parse_page self.url
    	unless page[:images_sized].empty?
    	  @content.images.build({ :remote_image_url => page[:images_sized].first[:url] })
    	end
    end

    begin
      if @content.save
      	set_published
      	NewswireSweeper.expire_newswires
      	return true
      else
      	errors.add(:content, @content.errors.full_messages.join('. '))
      	return false
      end
    rescue
      	errors.add(:content, "Blew up")
      return false
    end
  end

  def set_published
    self.update_attribute(:published, true)
  end

end
