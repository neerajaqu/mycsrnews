class Classified < ActiveRecord::Base
  include AASM

  acts_as_taggable_on :tags, :category, :subcategories, :location

  named_scope :active

  belongs_to :user

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title, :details, :user_id

  aasm_initial_state :unpublished

  aasm_state :unpublished
  aasm_state :available, :enter => [:expire, :set_published], :exit => :expire
  aasm_state :sold, :enter => :expire
  aasm_state :loaned_out
  aasm_state :expired, :enter => :expire
  aasm_state :closed
  aasm_state :hidden # what is this used for?

=begin
# REMOVE METHODS
  aasm_event :unpublish do
    transitions :to => :unpublished, :from => [:available, :sold, :loaned_out, :expired, :closed, :hidden]
  end
=end

  aasm_event :publish do
    transitions :to => :available, :from => [:unpublished]
  end

  aasm_event :renew do
    transitions :to => :available, :from => [:expired, :closed], :success => :update_renewed
  end

  aasm_event :sold do
    transitions :to => :sold, :from => :available
  end

  aasm_event :loan_out do
    transitions :to => :loaned_out, :from => :available
  end

  aasm_event :return do
    transitions :to => :available, :from => :loaned_out, :success => :update_renewed
  end

  aasm_event :expired do
    transitions :to => :expired, :from => [:unpublished, :available, :loaned_out, :hidden]
  end

  def set_published; puts "Publishing" end
  def set_unpublish; puts "Publishing" end
  def update_renewed; puts "Renewed" end
  def expire; puts "Expiring" end
  def loan_to user
    # create loaning
    loan_out!
  end
  def state() aasm_state end
end
