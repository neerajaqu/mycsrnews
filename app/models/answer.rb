class Answer < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable

  belongs_to  :user
  belongs_to  :question

  validates_presence_of :answer

end
