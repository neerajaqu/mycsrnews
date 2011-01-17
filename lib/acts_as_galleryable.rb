require 'active_record'

module Newscloud
  module Acts
    module Galleryable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_galleryable
          has_many :gallery_items, :as => :galleryable, :dependent => :nullify
          has_many :galleries, :through => :gallery_items

          accepts_nested_attributes_for :gallery_items,
            :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }

          include Newscloud::Acts::Galleryable::InstanceMethods
        end
      end

      module InstanceMethods
        def galleryable?
          true
        end

=begin
# TODO:: Get this working
        # Use a better base value
        def thumb_url
          nil
        end

        # Use a better base value
        def full_url
          nil
        end
=end

        def video_item?
          self.class.name == Video.name
        end

        def image_item?
          self.class.name == Image.name
        end

      end
    end
  end
end
