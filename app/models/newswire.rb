class Newswire < ActiveRecord::Base

  belongs_to :feed
  belongs_to :user
  has_one :content

  named_scope :unpublished, { :conditions => ["published = ?", false] }

  def quick_post user_id = nil
    user_id ||= self.feed.user_id
    return false unless user_id and user_id > 0

    @content = Content.new({
    	:title    => self.title,
    	:caption  => ActionController::Base.helpers.strip_tags(self.caption),
    	:url      => self.url,
    	:source   => self.feed.title,
    	:user_id  => user_id,
    	:newswire => self
    })

    if self.imageUrl.present?
    	@content.images.build({ :remote_image_url => self.imageUrl})
    else
    	page = Parse::Page.parse_page self.url
    	unless page[:images_sized].empty?
    	  @content.images.build({ :remote_image_url => page[:images_sized].first[:url] })
    	end
    end

    begin
      if @content.save
      	set_published
      	return true
      else
      	return false
      end
    rescue
      return false
    end
  end

  def set_published
    self.update_attribute(:published, true)
  end

end
