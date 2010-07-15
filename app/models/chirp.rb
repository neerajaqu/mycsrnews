class Chirp < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :recipient_id, :subject, :body
end
