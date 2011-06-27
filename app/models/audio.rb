class Audio < ActiveRecord::Base

  acts_as_moderatable
  acts_as_voteable

  belongs_to :user
  belongs_to :audioable, :polymorphic => true
  belongs_to :source

  validates_format_of :url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?\.mp3/i, :message => "should look like a URL ending in .mp3", :allow_blank => true
  validate :validate_url_or_embed

  before_save :set_user

  def set_user
    unless self.user.present? or self.audioable.nil?
      self.user = self.audioable.user if self.audioable.respond_to? :user
    end
  end

  def default_title
    title.present? ? title : url
  end

  private
    
    def validate_url_or_embed
      unless url.present? or embed_code.present?
        errors.add(:url, "URL or Embed Code must be present")
        errors.add(:embed_code, "Embed Code or URL must be present")
        return false
      else
        return true
      end
    end

end
