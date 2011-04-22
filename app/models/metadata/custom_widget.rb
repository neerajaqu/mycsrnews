class Metadata::CustomWidget < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  validates_format_of :title, :with => /^[A-Za-z _]+$/, :message => "Title must be present and may only contain letters and spaces"
  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes to they don't exist for the model
  validates_format_of :custom_data, :with => /^.+$/, :message => "Custom Data can't be blank"

  validate :on_content_type

  after_save :build_view_object

  def self.get_slot key_sub_type, key_name
    self.find_slot(key_sub_type, key_name)
  end

  def self.find_slot key_sub_type, key_name
    self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, key_name])
  end

  def self.content_types
    #['main_content', 'sidebar_content']
    ['panel-1', 'panel-2', 'panel-3']
  end

  def self.old_content_types
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

  def method_missing(name, *args)
    return self.send(name, *args) if self.respond_to? name, true
    init_data
    name = key_from_assign name
    if data[name].present?
      data[name] = args.first if args.present?
      return data[name]
    else
    	data[name] = args.empty? ? nil : args.first
    end
  end

  def custom_data() self.data[:custom_data] end
  def custom_data=(val) self.data[:custom_data] = val end

  private

  def on_content_type
    errors.add(:content_type, "You must select a valid content type") unless Metadata::CustomWidget.content_types.include?(self.content_type) or Metadata::CustomWidget.old_content_types.include?(self.content_type)
  end

  def set_meta_keys
    self.meta_type    = 'custom'
    self.key_type     = 'widget'
    self.key_sub_type ||= self.content_type.downcase.sub(/_content$/, '')
    self.key_name     ||= self.title.parameterize
  end

  def build_view_object
    return true if metadatable.present?
    return true unless valid_data? and metadatable.nil?
    view_object_template = nil
    case content_type
    when 'panel-1'
      view_object_template = ViewObjectTemplate.find_by_name("v2_single_col_custom_widget")
    when 'panel-2'
      view_object_template = ViewObjectTemplate.find_by_name("v2_double_col_custom_widget")
    when 'panel-3'
      view_object_template = ViewObjectTemplate.find_by_name("v2_triple_col_custom_widget")
    end
    return false unless view_object_template

    self.metadatable = ViewObject.new({
      :name                 => key_name,
      :view_object_template => view_object_template,
      :setting              => self
    })
    self.metadatable.save
    self.save
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
