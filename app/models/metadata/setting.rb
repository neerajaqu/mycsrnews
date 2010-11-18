class Metadata::Setting < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :setting_name, :with => /^.+$/, :message => "Setting Name can't be blank"
  validates_format_of :setting_value, :with => /^.+$/, :message => "Setting Value can't be blank"
  validates_format_of :setting_sub_type_name, :with => /^[A-Za-z _]+$/, :message => "Title may only contain letters and spaces", :allow_blank => true

  def self.get name, sub_type = nil
    self.find_setting(name, sub_type)
  end

  def self.get_setting name, sub_type = nil
    self.find_setting(name, sub_type)
  end

  def self.find_setting name, sub_type = nil
    return self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", sub_type, name]) if sub_type
    return self.find(:first, :conditions => ["key_name = ?", name])
  end

  def key() self.setting_name end

  def value
    if self.setting_value == "true"
      return true
    elsif self.setting_value == "false"
      return false
    else
      return self.setting_value
    end
  end

  def value= val
    self.setting_value = val
  end

  def enabled?
    !! self.value
  end

  def disabled?
    ! self.value
  end

  private

  def set_meta_keys
    self.meta_type    = 'setting'
    self.key_type     = 'app'
    self.key_sub_type ||= self.setting_sub_type_name
    self.key_name     ||= self.setting_name
  end

end
