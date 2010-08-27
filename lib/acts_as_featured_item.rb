require 'active_record'

module Newscloud
  module Acts
    module FeaturedItem

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_featured_item
          has_many :featured_items, :as => :featurable

          include Newscloud::Acts::FeaturedItem::InstanceMethods
        end
      end

      module InstanceMethods
        def featured_item?
          true
        end

        def featured_url
          # To use a custom path create a Model.featured_url function
          # and return as hash like so:
          # { :controller => '/stories', :action => 'show', :id => self }
          # lambda { story_path(self) } would be even slicker, but it doesn't work in rails
          self
        end

        def featured_image_url
          @default_image_url = APP_CONFIG['default_image']
          if self.respond_to?('images')
            return self.images.first.url(:medium) if self.images.present?
          else
            [:image_url, :get_image_url].each do |method|
              return self.send(method) if self.respond_to?(method) and self.send(method).present?
            end
          end
          @default_image_url
        end

        def featured_video
          return self.videos.first if self.respond_to?('videos') and self.videos.present?
          nil
        end

        def featured_title
          [:title, :name].each do |method|
            return self.send(method) if self.respond_to?(method) and self.send(method).present?
          end
          self.item_title
        end

        def featured_blurb
          [:caption, :details, :body, :comments].each do |method|
            return self.send(method) if self.respond_to?(method) and self.send(method).present?
          end
          nil
        end

        def featured_related_count
          self.comments_count
        end

        def featured_related_locale
          'comments'
        end

        def num_votes
          self.votes_tally
        end

        def num_comments
          self.comments_count
        end

      end
    end
  end
end
