class Metadata::SkipImage < Metadata
  after_save :remove_all_images
  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # taking these out to allow for partial strings
  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  # validates_format_of :image_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
  # validates_format_of :image_url, :with => /\.(jpg|jpeg|gif|png)/, :message => "Background must be an image (jpg, jpeg, gif or png)"

  def self.get image_url, sub_type = nil
    self.find_skip_image(image_url, sub_type)
  end

  private

  def set_meta_keys
    self.meta_type    = 'setting'
    self.key_type     = 'skip_image'
    self.key_sub_type ||= self.setting_sub_type_name
    self.key_name     ||= self.setting_name
  end

  def remove_all_images
    image_list = Image.find(:all, :conditions => ["remote_image_url like ?", "%#{self.image_url}%"])
    image_list.each do |image|
      current_imageable = image.imageable
      if image.destroy
        WrapperSweeper.expire_item current_imageable
      end
    end
  end
  
end
