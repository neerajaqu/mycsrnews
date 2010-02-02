class Article < ActiveRecord::Base
  has_one :content
  belongs_to :author, :class_name => "User"

  accepts_nested_attributes_for :content

  validates_presence_of :body
end
