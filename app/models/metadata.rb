class Metadata < ActiveRecord::Base
  serialize :data

  belongs_to :metadatable, :polymorphic => true

  named_scope :key, lambda { |*args| { :conditions => ["key_name = ?", args.first] } }
  named_scope :key_type_name, lambda { |*args| { :conditions => ["key_type = ? AND key_name = ?", args.first, args.second] } }
  named_scope :key_type_sub_name, lambda { |*args| { :conditions => ["key_type = ? AND key_sub_type = ? AND key_name = ?", args.first, args.second, args.third] } }
  named_scope :meta_type, lambda { |*args| { :conditions => ["meta_type = ?", args.first] } }

  before_save :set_meta_keys

  def self.find_by_key_type_name key_type, key_name
    self.key_type_name(key_type, key_name).first
  end

  def self.find_by_key_type_sub_name key_type, key_sub_type, key_name
    self.find(:first, :conditions => ["key_type = ? and key_sub_type = ? and key_name = ?", key_type, key_sub_type, key_name])
  end

  def self.get_ad_slot key_sub_type, key_name
    @ad_slot = self.key_type_sub_name('ads', key_sub_type, key_name).first
    @ad_slot = self.key_type_sub_name('ads', key_sub_type, 'default').first if @ad_slot.nil?
    @ad_slot
  end

  def self.get_default_ad_slot
    self.key_type_sub_name('ads', 'banner', 'default').first
  end

  def attributes= attrs
    begin
      super
    rescue ActiveRecord::UnknownAttributeError
      init_data
      attrs.each {|k,v| data[k.to_sym] = v }
    end
  end

# TODO:: port this method in
# from rails initializer.rb, cleaner
#  def method_missing(name, *args)
#    if name.to_s =~ /(.*)=$/
#      self[$1.to_sym] = args.first
#    else
#      self[name]
#    end
#  end

  def method_missing(name, *args)
    return self.send(name, *args) if self.respond_to? name
    init_data
    name = key_from_assign name
    if data[name].present?
      data[name] = args.first if args.present?
      return data[name]
    else
    	data[name] = args.empty? ? nil : args.first
    end
  end

  private

  def key_from_assign key
    key = $1 if key.to_s =~ /^(.*)=$/
    key.to_sym
  end

  def init_data
    self.data = {} if self.data.nil?
  end

  # overwrite in sub metadata models as needed
  def set_meta_keys
  end
  
end
