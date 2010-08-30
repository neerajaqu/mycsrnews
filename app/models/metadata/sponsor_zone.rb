class Metadata::SponsorZone < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :sponsor_zone_name, :with => /^.+$/, :message => "Name can't be blank"
  validates_format_of :sponsor_zone_topic, :with => /^[A-Za-z _]+$/, :message => "Topic may only contain letters and spaces", :allow_blank => true
  validates_format_of :sponsor_zone_code, :with => /^.+$/, :message => "Code can't be blank"

  def self.get name, sub_type = nil
    self.find_sponsor_zone(name, sub_type)
  end

  def self.find_sponsor_zone name, topic = nil
    return self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", topic, name]) if topic
    return self.find(:first, :conditions => ["key_name = ?", name])
  end

  private

  def set_meta_keys
    self.meta_type    = 'sponsor_zone'
    self.key_type     = 'zone'
    self.key_sub_type ||= self.sponsor_zone_topic
    self.key_name     ||= self.sponsor_zone_name
  end

end
