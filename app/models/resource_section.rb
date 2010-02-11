class ResourceSection < ActiveRecord::Base
   acts_as_taggable_on :tags

    named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }

    has_many :resources

    has_friendly_id :name, :use_slug => true, :reserved => RESERVED_NAMES
    validates_presence_of :name, :section, :description

    def to_s
      "Resource Section: #{name}"
    end
end