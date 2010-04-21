require 'open-uri'
require 'timeout'

class Image < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable

  belongs_to :user
  belongs_to :imageable, :polymorphic => true

  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  has_attached_file :image, :styles => {
  	:media_item => "72x48\!^",
  	:thumb => "90x90<",
  	:medium => "280x280>",
  	:featured => "280x280<"
  }

  #before_validation :download_image, :if => :remote_image_url?
  validate :download_image, :if => :remote_image_url?
  # TODO:: validate format of remote_image_url
  #validates_format_of :remote_image_url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*(jpg,jpeg,gif,png))?$/ix, :allow_blank => true, :message => "image url must point to a jpeg, gif or png image", :if => :remote_image_url?
  #validates_presence_of :remote_image_url, :allow_blank => true, :message => 'invalid image or url.', :if => :remote_image_url?
  validates_presence_of :image, :image_file_name, :image_content_type, :image_file_size

  #after_validation :set_user

  delegate :url, :to => :image

  private

  def set_user
    self.user = current_user unless self.user.present?
  end

  def download_image
    errors.add(:remote_image_url, "image url must point to a jpeg, gif or png image url") and return unless remote_image_url =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*(jpg,jpeg,gif,png))?$/ix
    begin
      Timeout::timeout(10) {
        self.image = open(URI.parse(remote_image_url))
      }
    rescue Timeout::Error, OpenURI::HTTPError, Exception
      errors.add(:remote_image_url, "Could not download image. Please select another image.")
    end
  end

end
