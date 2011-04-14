class ViewObject < ActiveRecord::Base
  
  belongs_to :view_object_template
  belongs_to :parent, :class_name => "ViewObject", :foreign_key => :parent_id
  #has_one :setting, :class_name => "Metadata::ViewObjectSetting", :as => :metadatable
  has_one :setting, :class_name => "Metadata", :as => :metadatable

  has_many :direct_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :parent_id, :order => "position desc"
  has_many :indirect_view_tree_edges, :class_name => "ViewTreeEdge", :foreign_key => :child_id, :order => "position desc"
  has_many :edge_children, :through => :direct_view_tree_edges, :source => :child, :order => "position desc"
  has_many :edge_parents, :through => :indirect_view_tree_edges, :source => :parent, :order => "position desc"

  def dataset
    return setting.load_dataset if setting and setting.dataset
    return setting.kommand_chain if setting
    @dataset ||= Content.active.top
  end

  def children
    self.class.find(:all, :conditions => ["parent_id = ?", self.id])
  end

  def self.load key_name
    self.find_by_name(key_name)
  end

  def add_parent! parent_view_object, position = 0
    ViewTreeEdge.create!({:parent => parent_view_object, :child => self, :position => position})
  end

  def add_child! child_view_object, position = 0
    ViewTreeEdge.create!({:child => child_view_object, :parent => self, :position => position})
  end

end
