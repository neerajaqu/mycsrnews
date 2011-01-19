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
          named_scope :user_items, { :conditions => 
              "#{self.name.tableize}.user_id not in (select id from users where is_editor = true or is_moderator = true or is_admin = true)" }
          named_scope :curator_items, { :conditions => 
              "#{self.name.tableize}.user_id in (select id from users where is_editor = true or is_moderator = true or is_admin = true)" }

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
          self.cascade_block_pfeed_items self.is_blocked
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
            	items = Array(self.send(association.name)).flatten.compact

            	items.each do |item|
            	  if item.moderatable?
                  item.update_attribute(:is_blocked, blocked) unless item.is_blocked == blocked
                  item.expire
                  item.cascade_block blocked if item.respond_to? :cascade_block
                  item.cascade_block_pfeed_items blocked
                end
            	end
            end
          end
          return true
        end

        def cascade_block_pfeed_items blocked = nil
          PfeedItem.find(:all, :conditions => ["participant_type = ? and participant_id = ?", self.class.name, self.id]).each do |pitem|
            pitem.update_attribute(:is_blocked, blocked || false)
            pitem.participant.cascade_block blocked if pitem.participant.moderatable?
          end
        end

        def verify_cascade blocked = nil
          [self.class.reflect_on_all_associations(:has_many), self.class.reflect_on_all_associations(:has_one)].flatten.each do |association|
            if not association.options.include?(:through)
            	items = Array(self.send(association.name)).flatten.compact

            	count = 0
            	items.each do |item|
            	  if item.moderatable?
                  raise "Block Discrepancy: #{item.inspect}" unless item.is_blocked == blocked
                  item.verify_cascade blocked if item.respond_to? :verify_cascade
                end
            	end
            end
          end
          return true
        end

      end
    end
  end
end
