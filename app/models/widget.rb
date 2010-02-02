class Widget < ActiveRecord::Base
  
  named_scope :main, { :conditions => ["content_type ='main_content'"] }
  named_scope :sidebar, { :conditions => ["content_type ='sidebar_content'"] }
end
