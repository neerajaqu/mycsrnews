class ViewTreeEdge < ActiveRecord::Base
  belongs_to :parent, :class_name => "ViewObject"
  belongs_to :child, :class_name => "ViewObject"
end
