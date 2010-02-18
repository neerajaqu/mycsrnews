require 'active_record'

module Newscloud
  module Acts
    module MediaItem

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_media_item
          has_many :images, :as => :imageable, :dependent => :nullify
          has_many :videos, :as => :videoable, :dependent => :destroy
          has_many :audios, :as => :audioable, :dependent => :destroy

          accepts_nested_attributes_for :images,
            :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }
          accepts_nested_attributes_for :videos,
            :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }
          accepts_nested_attributes_for :audios,
            :reject_if => proc { |attrs| attrs.all? { |k,v| v.blank? } }

          include Newscloud::Acts::MediaItem::InstanceMethods
        end
      end

      module InstanceMethods
        def media_item?
          true
        end

        def image_item?
          self.images.count > 0 ? true : false
        end

        def video_item?
          self.videos.count > 0 ? true : false
        end

        def audio_item?
          self.audios.count > 0 ? true : false
        end

      end
    end
  end
end
