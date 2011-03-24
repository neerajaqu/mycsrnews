require 'active_record'

module Newscloud
  module Acts
    module ViewObject

      def self.included(base)
        base.extend ClassMethods
      end

      def self.default_args_count *args
        options = args.extract_options!
        required  = options[:required] || false
        range     = options[:range] || (1..20)
        label     = options[:label] || 'count'
        return {
          :label    => label,
          :type     => Fixnum,
          :required => required,
          :range    => range.to_a
        }
      end

      module ClassMethods
        def acts_as_view_object

          include Newscloud::Acts::ViewObject::InstanceMethods
          extend Newscloud::Acts::ViewObject::ViewObjectClassMethods

        end
      end

      module ViewObjectClassMethods

        def view_object?
          true
        end

        def view_object_methods
          {}
        end

        def default_args_count *args
          options = args.extract_options!
          required  = options[:required] || false
          range     = options[:range] || (1..20)
          label     = options[:label] || 'count'
      	  return {
      	  	:label    => label,
      	  	:type     => Fixnum,
      	  	:required => required,
      	  	:range    => range.to_a
          }
        end

        def valid_method? method_name, args = []
          Rails.logger.debug "***Validating method"
          wmethod = self.view_object_methods[method_name.to_sym]
          return false unless wmethod.present?
          return false unless args.is_a? Array
          return false if args.size > wmethod[:args].size
          Rails.logger.debug "*** Method valid"
          if wmethod[:args].any?
            Rails.logger.debug "*** Validating args"
          	wmethod[:args].each_with_index do |arg,index|
              Rails.logger.debug "*** Validating arg(#{index}) #{arg.inspect}"
          	  val = args[index]
              Rails.logger.debug "*** Arg value is: (#{val})"
          	  return false if val.nil? and arg[:required]
          	  next if val.nil? and not arg[:required] 
              Rails.logger.debug "*** Arg type is: (#{val.class.name})"
          	  return false unless val.is_a? arg[:type]
              Rails.logger.debug "*** Arg val(#{val}) in range #{arg[:range].inspect}?"
              return false if arg[:range].present? and not arg[:range].include?(val)
              Rails.logger.debug "*** Arg validated successfully!"
          	end
          end
          return true
        end

      end

      module InstanceMethods

        def view_object?
          true
        end

      end
    end
  end
end
