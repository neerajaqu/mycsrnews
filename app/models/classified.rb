class Classified < ActiveRecord::Base
  include AASM

  acts_as_taggable_on :tags, :category, :subcategories, :location
  acts_as_voteable 
  acts_as_media_item

  acts_as_featured_item
  #acts_as_moderatable
  acts_as_relatable
  acts_as_wall_postable
  acts_as_tweetable
  
  named_scope :active

  belongs_to :user

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title, :details, :user_id

  aasm_initial_state :unpublished

  aasm_state :unpublished
  aasm_state :available, :enter => [:expire, :set_published], :exit => :expire
  aasm_state :sold, :enter => :expire
  aasm_state :loaned_out, :enter => :expire
  aasm_state :expired, :enter => :expire
  aasm_state :closed, :enter => :expire
  aasm_state :hidden, :enter => :expire

=begin
# REMOVE METHODS
  aasm_event :unpublish do
    transitions :to => :unpublished, :from => [:available, :sold, :loaned_out, :expired, :closed, :hidden]
  end
=end

  aasm_event :published do
    transitions :to => :available, :from => [:unpublished]
  end

  aasm_event :renewed do
    transitions :to => :available, :from => [:expired, :closed, :hidden], :success => :update_renewed
  end

  aasm_event :closed do
    transitions :to => :closed, :fromt => [:hidden, :available, :loaned_out]
  end

  aasm_event :sold do
    transitions :to => :sold, :from => :available
  end

  aasm_event :loaned_out do
    transitions :to => :loaned_out, :from => :available
  end

  aasm_event :returned do
    transitions :to => :hidden, :from => :loaned_out, :success => :update_renewed
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
    loaned_out!
  end
  def state() aasm_state end
  
  def comments_count
    0
  end
  
  def votes_count
    0
  end
  
end
