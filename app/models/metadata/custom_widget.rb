class Metadata::CustomWidget < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  validates_format_of :title, :with => /^[A-Za-z _]+$/, :message => "Title must be present and may only contain letters and spaces"
  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes to they don't exist for the model
  validates_format_of :custom_data, :with => /^.+$/, :message => "Custom Data can't be blank"

  validate :on_content_type

  before_save :build_widget

  def self.get_slot key_sub_type, key_name
    self.find_slot(key_sub_type, key_name)
  end

  def self.find_slot key_sub_type, key_name
    self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, key_name])
  end

  def self.content_types
    ['main_content', 'sidebar_content']
  end

  def valid_data?
    custom_data != '**default**'
  end

  def main_content?
    content_type == 'main_content'
  end

  def sidebar_content?
    content_type == 'sidebar_content'
  end

  def has_widget?
    self.metadatable.present?
  end

  private

  def on_content_type
    errors.add(:content_type, "You must select a valid content type") unless Metadata::CustomWidget.content_types.include?(self.content_type)
  end

  def set_meta_keys
    self.meta_type    = 'custom'
    self.key_type     = 'widget'
    self.key_sub_type = self.content_type.downcase.sub(/_content$/, '')
    self.key_name     = self.title.parameterize
  end

  def build_widget
    return true unless valid_data? and metadatable.nil?

    @widget = Widget.create!({
    	:name => key_name,
    	:content_type => content_type,
    	:partial => 'shared/custom_widget'
    })
    self.metadatable = @widget

    @widget
  end

end
