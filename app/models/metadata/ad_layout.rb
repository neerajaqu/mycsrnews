class Metadata::AdLayout < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :ad_layout_name, :with => /^.+$/, :message => "Layout can't be blank"
  validates_format_of :ad_layout_layout, :with => /^.+$/, :message => "Layout can't be blank"

  def self.get name, sub_type = nil
    self.find_ad_layout(name, sub_type)
  end
  
  def self.find_ad_layout name, key_sub_type = nil
    return self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, name]) if key_sub_type
    return self.find(:first, :conditions => ["key_name = ?", name])
  end

  def key() self.ad_layout_name end

  def layout
    self.ad_layout_layout
  end

  private

  def set_meta_keys
    self.meta_type    = 'ad_layout'
    self.key_type     = 'app'
    self.key_sub_type ||= self.ad_layout_sub_type_name
    self.key_name     ||= self.ad_layout_name
  end

end
