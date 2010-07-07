require 'active_record'

module Newscloud
  module Acts
    module Relatable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_relatable    
          has_many :related_items, :as => :relatable
          named_scope :list_items, lambda { |*args| { :order => ["title asc"], :limit => (args.first || 12)} }
          accepts_nested_attributes_for :related_items
          include Newscloud::Acts::Relatable::InstanceMethods
        end
      end

      module InstanceMethods
        def relatable?
          true
        end

      end
    end
  end
end
