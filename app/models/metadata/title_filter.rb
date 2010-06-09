class Metadata::TitleFilter < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :keyword, :with => /^([-a-zA-Z0-9|_ ]+,?)+$/, :allow_blank => false, :message => "Invalid keywords. Keywords can be alphanumeric characters or -_ or a blank space."

  def self.get keyword, sub_type = nil
    self.find_title_filter(keyword, sub_type)
  end

  private

  def set_meta_keys
    self.meta_type    = 'setting'
    self.key_type     = 'title_filter'
    self.key_sub_type ||= self.setting_sub_type_name
    self.key_name     ||= self.setting_name
  end

end
