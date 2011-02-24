class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :categorizable, :polymorphic => true

  validates_uniqueness_of :category_id, :scope => [:categorizable_type, :categorizable_id]

  validate :validate_category_type_on_categorizable

  private

    def validate_category_type_on_categorizable
      errors.add(:category, "must be selected") unless category_id.present?
      errors.add(:category, "must be a valid type") unless valid_category?
    end

    def valid_category?
      !! Category.find_for_model_and_id(categorizable_type, category_id)
    end
end
