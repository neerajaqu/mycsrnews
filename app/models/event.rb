class Event < ActiveRecord::Base
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable
  acts_as_relatable
 
  named_scope :newest, lambda { |*args| { :conditions => ["start_time > now()"], :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1 AND start_time > now()"],:order => ["created_at desc"], :limit => (args.first || 3)} }
  named_scope :upcoming, lambda { |*args| { :conditions => ["start_time > now()"], :order => ["start_time asc"], :limit => (args.first || 10)} }

  belongs_to :user

  has_many :comments, :as => :commentable
  has_one :tweeted_item, :as => :item
  attr_accessor :tags_string

  has_friendly_id :name, :use_slug => true

  validates_presence_of :name
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validates_format_of :alt_url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  
  
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
          :source => "Facebook",
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
          :url => "http://www.facebook.com/event.php?eid="+facebook_event.eid.to_s)
      e.images.create(:remote_image_url=>facebook_event.pic) if facebook_event.pic
    end
  end

  def self.create_from_zvent_event(zvent, user)
    return nil if not zvent.is_a? Zvent::Event
    check  = Event.find_by_eid(zvent.id)
    if check
      return check
    else
      image = (zvent.images.empty? ? nil : zvent.images.first["url"]) || (zvent.venue.images.empty? ? nil : zvent.venue.images.first["url"])
      url = zvent.url || "http://www.zvents.com"+zvent.zurl
      alt_url = "http://www.zvents.com"+zvent.zurl
      if Metadata::Setting.find_setting('zvents_replacement_url').present?
        replacement_url = Metadata::Setting.find_setting('zvents_replacement_url').value
        if replacement_url.present?
          url = url.gsub("www.zvents.com", replacement_url)
          alt_url = alt_url.gsub("www.zvents.com", replacement_url)
        end
      end
      e = Event.create!(
      :source => "Zvent",
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
      :url => url,
      :alt_url => alt_url)
      
      e.images.create(:remote_image_url=>image) if image
    end
  end

  def get_url
    return "http://#{url}" unless url.empty? or url =~ /^http:\/\//
    url
  end

  def get_view_button_url
    if alt_url.present?
      return "http://#{alt_url}" unless alt_url =~ /^http:\/\//
      alt_url
    else
      get_url
    end
  end

end

