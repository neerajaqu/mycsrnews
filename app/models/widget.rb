class Widget < ActiveRecord::Base

  has_many :metadatas, :as => :metadatable
  
  named_scope :main, { :conditions => ["content_type ='main_content'"] }
  named_scope :sidebar, { :conditions => ["content_type ='sidebar_content'"] }

  def metadata
    self.metadatas.first
  end

  def css_class
    ''
  end
end
