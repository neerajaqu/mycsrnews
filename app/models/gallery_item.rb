class GalleryItem < ActiveRecord::Base

  belongs_to :gallery
  belongs_to :user
  belongs_to :galleryable, :polymorphic => true, :touch => true

  accepts_nested_attributes_for :galleryable

  default_scope :order => "position desc, created_at asc"

  named_scope :positioned, :order => "position desc, created_at asc"
  #validates_presence_of :user, :gallery, :title
  #validates_presence_of :item_url
  before_validation :gallery_user
  validate :build_item
  before_save :set_item_info

  delegate :thumb_url, :to => :galleryable
  delegate :medium_url, :to => :galleryable
  delegate :full_url, :to => :galleryable

  def item_title
    title || galleryable.item_title
  end

  def item_description
    caption || galleryable.item_description
  end

  def expire
    self.class.sweeper.expire_gallery_item_all self
  end

  def self.expire_all
    self.sweeper.expire_gallery_item_all self.new
  end

  def self.sweeper
    GallerySweeper
  end

  private

  def gallery_user
    unless self.user.present?
      if self.galleryable.nil?
        self.user = self.gallery.user
      else
        self.user = self.galleryable.user
      end
    end
  end

  def build_item
    return true if self.galleryable.present?
    return true unless self.new_record? or item_url_changed?
    errors.add(:item_url, "item url must be present") if self.new_record? and item_url.nil?

    if Image.image_url? item_url
    	self.galleryable = Image.new(:remote_image_url => item_url, :user => user)
    elsif Video.youtube_url? item_url
      self.galleryable = Video.new(:remote_video_url => item_url, :user => user)
    elsif Video.vimeo_url? item_url
      self.galleryable = Video.new(:remote_video_url => item_url, :user => user)
    else
      errors.add(:item_url, "item url must point to an image, or a youtube or vimeo url")
    end
    # HACK:: Video.process_video stopped getting triggered, so trigger it
    self.galleryable and self.galleryable.valid?
  end

  def set_item_info
    self.title = self.galleryable.item_title unless self.title.present?
    self.caption = self.galleryable.item_description unless self.caption.present?
  end

end
