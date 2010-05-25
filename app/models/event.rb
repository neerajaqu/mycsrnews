class Event < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  belongs_to :user

  has_many :comments, :as => :commentable
  attr_accessor :tags_string

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."
  
  def self.per_page; 10; end

  def self.top
    self.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
  end
  
  def self.create_from_facebook_event(facebook_event, user)
    return nil if not facebook_event.is_a? Facebooker::Event
    check = Event.find_by_eid(facebook_event.eid)
    if check
      return check
    else
      e = Event.create!(
          :user => user,
          :name => facebook_event.name,
          :eid => facebook_event.eid,
          :start_time => Time.at(facebook_event.start_time.to_i),
          :end_time => Time.at(facebook_event.end_time.to_i),
          :description => facebook_event.description,
          :location => facebook_event.location,
          :street => facebook_event.venue[:street],
          :city => facebook_event.venue[:city],
          :state => facebook_event.venue[:state],
          :country => facebook_event.venue[:country],
          #:privacy_type => facebook_event.privacy,
          :creator => facebook_event.creator,
          :pic => facebook_event.pic,
          :pic_big => facebook_event.pic_big,
          :pic_small => facebook_event.pic_small,
          :update_time => facebook_event.update_time,
          :tagline => facebook_event.tagline,
          :url => "http://www.facebook.com/event.php?eid="+facebook_event.eid)
    end
  end

  def self.create_from_zvent_event(zvent, user)
    return nil if not zvent.is_a? Zvent::Event
    check  = Event.find_by_eid(zvent.id)
    if check
      return check
    else
      image = zvent.images.empty? ? nil : zvent.images.first["url"] 
      Event.create!(
      :user => user,
      :name => zvent.name,
      :eid => zvent.id,
      :start_time => zvent.startTime,
      :end_time => zvent.endTime,
      :description => zvent.description,
      :location => zvent.venue.name,
      :street => zvent.venue.address,
      :city => zvent.venue.city,
      :state => zvent.venue.state,
      :country => zvent.venue.country,
      :creator => nil, #not yet support in gem
      :pic => image,
      :url => "http://www.zvents.com/"+zvent.zurl)
    end
  end
end

