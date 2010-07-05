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

        def related_item relatable_type,current_user
          #return false unless RelatedItem.valid_relatable_type? relatable_type

          @related_item = self.related_items.build({ :relatable_type => relatable_type })
          @related_item.user = current_user

          return @related_item.save
        end

      end
    end
  end
end
