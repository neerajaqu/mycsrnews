require 'active_record'

module Newscloud
  module Acts
    module Moderatable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_moderatable
          has_many :flags, :as => :flaggable

          named_scope :active, { :conditions => ["#{self.name.tableize}.is_blocked = 0"] }
          named_scope :inactive, { :conditions => ["#{self.name.tableize}.is_blocked = 1"] }

          include Newscloud::Acts::Moderatable::InstanceMethods
        end
      end

      module InstanceMethods
        def moderatable?
          true
        end

        def blockable?
          self.respond_to?('is_blocked') ? true : false
        end

        def featurable?
          self.respond_to?('is_featured') ? true : false
        end

        def blocked?
          return self.is_blocked if self.respond_to?('is_blocked')
          false
        end

        def featured?
          return self.is_featured if self.respond_to?('is_featured')
          false
        end

        def flagged?
          self.flags.present? ? self.flag_count : false
        end

        def flag_count
          self.flags.count
        end

        def flag_item flag_type,current_user
          return false unless Flag.valid_flag_type? flag_type

          @flag = self.flags.build({ :flag_type => flag_type })
          @flag.user = current_user

          return @flag.save
        end

        def toggle_blocked
          self.is_blocked = ! self.is_blocked
          return self.save ? true : false
        end

        def toggle_featured
          self.is_featured = ! self.is_featured
          self.featured_at = Time.now if self.respond_to?('featured_at')
          return self.save ? true : false
        end

      end
    end
  end
end
