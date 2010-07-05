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
          named_scope :related_items, lambda { |*args| { :order => ["title asc"], :limit => (args.first || 12)} }
                
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
