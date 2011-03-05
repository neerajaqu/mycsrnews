class Metadata::ViewObjectSetting < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  validates_format_of :view_object_name, :with => /^[A-Za-z0-9 _]+$/, :message => "View Object Name must be present and may only contain letters and spaces"
  validates_format_of :klass_name, :with => /^[A-Za-z _]+$/, :message => "Klass Name must be present and may only contain letters and spaces"
  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes to they don't exist for the model
  validate :validate_kommands
  attr_accessible :data

  #before_save :build_view_object

  def self.get_slot key_sub_type, key_name
    self.find_slot(key_sub_type, key_name)
  end

  def self.find_slot key_sub_type, key_name
    self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, key_name])
  end

  def self.content_types
    ['main_content', 'sidebar_content']
  end

  def view_object
    metadatable
  end

  def view_object=(vo)
    metadatable = vo
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

  def has_view_object?
    self.metadatable.present?
  end

  def kommand_chain
    self.kommands.inject(self.klass_name.constantize) {|klass,kommand| klass.send(kommand[:method_name], *([kommand[:args], kommand[:options]].flatten)) }
  end

  def add_kommand *args
    options = args.extract_options!
    method_name =  args.shift
    raise "Missing argument" unless method_name
    kommand = {
    	:method_name => method_name
    }
    kommand[:args] = args if args.any?
    kommand[:options] = options if options.any?
    if self.kommands
    	self.kommands << kommand
    else
    	self.kommands = [kommand]
    end
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

  def locale_title() self.data[:locale_title] end
  def locale_title=(val) self.data[:locale_title] = val end
  def locale_subtitle() self.data[:locale_subtitle] end
  def locale_subtitle=(val) self.data[:locale_subtitle] = val end

  def respond_to? method, internal = false
    #return true if method.to_s == "data"
    return true if super method
    return true if not internal and method.to_s =~ /=$/
    return false if internal
    
    #init_data
    self.data[method].present?
    #return self.data
  end

  private

  def validate_kommands
    return true if self.kommands.any?
  end

  def on_content_type
    errors.add(:content_type, "You must select a valid content type") unless Metadata::CustomWidget.content_types.include?(self.content_type)
  end

  def set_meta_keys
    self.meta_type    = 'view_object'
    self.key_type     = 'setting'
    #self.key_sub_type ||= self.content_type.downcase.sub(/_content$/, '')
    self.key_name     ||= self.view_object_name.parameterize
  end

  def build_view_object
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
