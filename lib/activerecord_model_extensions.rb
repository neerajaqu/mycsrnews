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

      def top_article_items limit = 100
        table = self.name.tableize
        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked = 0 AND article_id is NOT NULL) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
      end
      
      def top_story_items(limit = 100, within_last_week = false)
        table = self.name.tableize
        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        if !within_last_week
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked = 0 AND article_id is NULL) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        else
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE (is_blocked = 0 AND article_id is NULL AND created_at > date_sub("#{now}", INTERVAL 7 DAY) ) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        end
      end
      
      def top_items(limit = 100, within_last_week = false)
        # TODO:: this needs work
        return self.all(:order => "created_at desc", :limit => limit) unless self.columns.select {|col| col.name == 'votes_tally'}

        table = self.name.tableize
        now = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
        # HACK ALERT
        # This will return an ordered set of results based on number of votes and time since posting
        if self.columns.select {|col| col.name == 'is_blocked'}
          if !within_last_week
            self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE is_blocked = 0 ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
          else
            self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} WHERE is_blocked = 0 AND created_at > date_sub("#{now}", INTERVAL 7 DAY) ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
          end
        else
          self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("#{now}") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
        end
        #self.find_by_sql %{SELECT ((1 + (votes_tally * 2)) / (((UNIX_TIMESTAMP("2010-03-23 14:20:24") - UNIX_TIMESTAMP(created_at)) / 3600) + 5)) AS item_score, #{table}.* FROM #{table} JOIN (SELECT ID FROM #{table} ORDER BY created_at DESC LIMIT 100) AS sub_#{table} ON #{table}.id = sub_#{table}.id ORDER BY item_score DESC LIMIT #{limit};}
      end

    end

    module InstanceMethods

      # Misc continuity methods for working with mixins
      def wall_postable?() false end
      def moderatable?() false end
      def refineable?() false end
      def relatable?() false end
      def featured_item?() false end
      def media_item?() false end
      def image_item?() false end
      def video_item?() false end
      def audio_item?() false end
      def downvoteable?() false end
      def scorable?() false end

      # model unique identifier
      def muid
        "#{self.class.name.underscore}_#{self.id}"
      end

      def item_link
        self
      end
      
      def wall_caption
        return ''
      end
            
      def item_title
        [:title, :name, :question].each do |method|
          return self.send(method) if self.respond_to?(method) and self.send(method).present?
        end
        "#{self.class.name.titleize} ##{self.id}"
      end

      def item_description
        [:description, :caption, :blurb, :details, :details].each do |method|
          return self.send(method) if self.respond_to?(method) and self.send(method).present?
        end
        "#{self.class.name.titleize} ##{self.id}"
      end

      # Breadcrumb parents method
      # Overwrite as [self.story.crumb_items]
      def crumb_parents
        []
      end

      def crumb_items
        [self, self.crumb_parents].flatten
      end

      def crumb_text
        self.item_title
      end

      def crumb_link
        self
      end

    end

  end
end
