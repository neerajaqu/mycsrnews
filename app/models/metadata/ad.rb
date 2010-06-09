class Metadata::Ad < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  validates_format_of :width, :with => /^[0-9]+(px)?$/, :message => "Width must be a number optionally ending in px"
  validates_format_of :height, :with => /^[0-9]+(px)?$/, :message => "Height must be a number optionally ending in px"
  validates_format_of :background, :with => /(jpg|jpeg|gif|png)$/, :message => "Background must be an image (jpg, jpeg, gif or png)"
  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :name, :with => /^.+$/, :message => "Name can't be blank"

  def self.get_default_slot
    self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", 'banner', 'default'])
  end

  def self.get_slot key_sub_type, key_name
    self.find_slot(key_sub_type, key_name) or self.get_default_slot
  end

  def self.find_slot key_sub_type, key_name
    self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, key_name])
  end

  private

  def set_meta_keys
    self.meta_type    = 'config'
    self.key_type     = 'ads'
    self.key_sub_type ||= self.name
    self.key_name     ||= 'default'
  end

end
