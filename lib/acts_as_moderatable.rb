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
          cascade_block self.is_blocked
          return self.save ? true : false
        end

        def toggle_featured
          self.is_featured = ! self.is_featured
          self.featured_at = Time.now if self.respond_to?('featured_at')
          return self.save ? true : false
        end

        def cascade_block blocked = nil
          [self.class.reflect_on_all_associations(:has_many), self.class.reflect_on_all_associations(:has_one)].flatten.each do |association|
            if not association.options.include?(:through)
            	puts "Triggering cascading block for #{association.macro} #{association.name}"
            	items = Array(self.send(association.name)).flatten.compact

            	count = 0
            	items.each do |item|
            	  #if item.class.included_modules.include? Newscloud::Acts::Moderatable
            	  if item.moderatable?
            	  	Rails.logger.debug "*******#{item.class.name} is missing :is_blocked field" and break unless item.respond_to? :is_blocked
            	  	item.toggle_blocked
            	  	Rails.logger.debug "##############FIXING BLOCKED VALUE for #{item.class.name} -- #{item.id}###############" unless blocked.nil? or item.is_blocked == blocked
            	  	item.is_blocked = blocked and item.save unless blocked.nil? or item.is_blocked == blocked
            	  	APP_CONFIG[:mismatches].push "#{item.class.name} -- #{item.id}" unless blocked.nil? or item.is_blocked == blocked
                  count += 1
            	  	Rails.logger.debug "*******BLOCKED VALUE MISMATCH: GOT #{item.is_blocked.to_s} EXPECTED #{blocked.to_s}" unless blocked.nil? or blocked == item.is_blocked
                  #puts "\tTriggering cascading block for #{item.class.name.titleize}--#{item.item_title}" if item.respond_to?(:blockable?) and item.blockable?
                  #puts "\n\n\n\n\n\n\n**************************************START NESTED BLOCK" if item.respond_to? :cascade_block
                  item.expire
                  item.cascade_block blocked if item.respond_to? :cascade_block
                  #puts "**************************************END NESTED BLOCK\n\n\n\n\n\n\n" if item.respond_to? :cascade_block
                end
            	end
            	puts "\tBlocked #{count} #{association.name}"
            end
          end
          return true
        end

      end
    end
  end
end
