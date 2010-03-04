class Metadata < ActiveRecord::Base
  serialize :data

  belongs_to :metadatable, :polymorphic => true

  named_scope :key, lambda { |*args| { :conditions => ["key_name = ?", args.first] } }
  named_scope :key_type_name, lambda { |*args| { :conditions => ["key_type = ? AND key_name = ?", args.first, args.second] } }
  named_scope :meta_type, lambda { |*args| { :conditions => ["meta_type = ?", args.first] } }

  attr_accessor :title, :custom_data, :content_type

  def self.find_by_key_type_name key_type, key_name
    self.key_type_name(key_type, key_name).first
  end

end
