class PredictionScore < ActiveRecord::Base
  belongs_to  :user
  named_scope :top, lambda { |*args| { :order => ["accuracy desc"], :limit => (args.first || 5), :conditions => [" correct_count > 0"]} }

end
