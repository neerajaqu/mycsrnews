require 'active_record'

module Newscloud
  module ActiverecordModelExtensions
    
    def self.included(base)
      base.send :extend, ClassMethods
      
      base.send :include, InstanceMethods
    end

    module ClassMethods

      def refineable?
        false
      end

    end

    module InstanceMethods

      def moderatable?
        false
      end

      def refineable?
        false
      end

      def featured_item?
        false
      end

      def media_item?
        false
      end

      def image_item?
        false
      end

      def video_item?
        false
      end

      def audio_item?
        false
      end

    end

  end
end
