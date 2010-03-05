class WidgetPage < ActiveRecord::Base
  acts_as_tree

  belongs_to :widget

  def widget?
    self.widget.present?
  end

  def layout_content?
    !self.root? and !self.widget?
  end

  def root?
    self.parent_id.nil?
  end

  def self.find_root_by_page_name(page)
    self.find(:all, :conditions => ["parent_id IS NULL and name = ?", page]).first
  end

  def css_class
    return '' unless self.position == 'left' || self.position == 'right'
    self.position
  end
end
