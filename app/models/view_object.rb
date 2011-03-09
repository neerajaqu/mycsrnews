class ViewObject < ActiveRecord::Base
  
  belongs_to :view_object_template
  belongs_to :parent, :class_name => "ViewObject", :foreign_key => :parent_id
  has_one :setting, :class_name => "Metadata::ViewObjectSetting", :as => :metadatable

  has_many :direct_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :parent_id
  has_many :indirect_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :child_id
  has_many :edge_children, :through => :direct_view_tree_edges, :source => :child
  has_many :edge_parents, :through => :indirect_view_tree_edges, :source => :parent

  def dataset
    return setting.kommand_chain if setting
    @dataset ||= Content.active.top
  end

  def children
    self.class.find(:all, :conditions => ["parent_id = ?", self.id])
  end

  def self.load key_name
    self.find_by_name(key_name)
  end

end
