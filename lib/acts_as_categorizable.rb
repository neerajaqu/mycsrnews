require 'active_record'

module Newscloud
  module Acts
    module Categorizable

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_categorizable
          has_many :categorizations, :as => :categorizable
          has_many :categories, :through => :categorizations, :conditions => ["parent_id IS NULL"]
          has_many :subcategories, :source => :category, :through => :categorizations, :conditions => ["parent_id IS NOT NULL"]

          accepts_nested_attributes_for :categorizations

          #validate :validate_category_type
          #validate :validate_subcategory_type

          include Newscloud::Acts::Categorizable::InstanceMethods
          extend Newscloud::Acts::Categorizable::CategorizableClassMethods
        end

        def categorizable?() false end
      end

      module CategorizableClassMethods
        def categorizable?() true end

        def add_category name
          Category.add_default_category_for self, name
        end

        def categories
          Category.default_categories_on self
        end

        def sorted_categories
          self.categories.find(:all, :order => "name asc")
        end

        def subcategories
          Category.default_subcategories_on self
        end

        def valid_category? name
          self.categories.map(&:name).include? name.to_s
        end

        def valid_subcategory? name
          self.subcategories.map(&:name).include? name.to_s
        end

        def category_counts limit = 7
          Categorization.find(:all, :conditions => ["categorizable_type = ?", self.name], :group => :category_id, :select => "count(*) count, category_id", :include => :category, :order => "count desc", :limit => limit)
        end
      end

      module InstanceMethods

        def categorizable?
          true
        end

        def category
          categories.first
        end

        def category_name
          category.try(:name)
        end

        def subcategory
          subcategories.first
        end

        def add_category category
          self.categorizations << Categorization.new(:categorizable => self, :category => category)
        end

        private
          def validate_category_type
            errors.add(:category_list, "must be a valid category group") unless self.valid_category?
          end

          def validate_subcategory_type
            errors.add(:subcategory_list, "must be a valid subcategory group") unless self.valid_subcategory?
          end
      end
    end
  end
end
