class Message < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :subject, :body, :email
  validates_format_of   :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_length_of   :email, :within => 6..100
end
