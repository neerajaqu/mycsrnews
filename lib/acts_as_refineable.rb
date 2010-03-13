require 'active_record'

module Newscloud
  module Acts
    module Refineable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_refineable

          include Newscloud::Acts::Refineable::InstanceMethods
          extend Newscloud::Acts::Refineable::RefineClassMethods
        end
      end

      module RefineClassMethods

        def refineable?
          true
        end

        def refine(params)
          refineable_params = ['sort_by', 'category', 'section']
          
          chains = []
          params.each do |key, value|
            next unless refineable_params.index(key)
            if key == 'sort_by'
            	value = value.downcase
              chains << value if self.respond_to?(value) and self.valid_refine_type?(value)
            elsif key == 'category'
            elsif key == 'section'
            end
          end

          result = chains.empty? ?
            self.all(:limit => 10, :order => "created_at desc") :
            chains.inject(self) { |chain, scope| chain.send(scope) }
        end

        def valid_refine_type? value
          ['newest', 'top'].include? value
        end

        def self.refineable_select_options
          ['Newest', 'Top'].collect { |k| [k, k] }
        end

      end

      module InstanceMethods

        def refineable?
          true
        end

      end
    end
  end
end
