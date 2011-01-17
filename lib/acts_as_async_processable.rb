require 'active_record'

module Newscloud
  module Acts
    module AsyncProcessable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def processable?() false end

        def acts_as_async_processable

          include Newscloud::Acts::AsyncProcessable::InstanceMethods
          extend Newscloud::Acts::AsyncProcessable::AsyncProcessClassMethods
          self.instance_variable_set '@queue', self.name.tableize.to_sym
        end
      end

      module AsyncProcessClassMethods
        @queue = self.name.tableize.to_sym

        def processable?
          true
        end

        def perform(id, method, *args)
          puts "RUNNING #{method} with #{args.inspect}"
          find(id).send(method, *args)
        end
      end

      module InstanceMethods
        def processable?
          true
        end

        def async(method, *args)
          Resque.enqueue(self.class, id, method, *args)
        end

        def async_process(*args)
          return nil unless self.respond_to? :process
          Resque.enqueue(self.class, :process, *args)
        end
      end

    end
  end
end
