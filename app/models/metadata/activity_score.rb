class Metadata::ActivityScore < Metadata

  named_scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }

  # HACK:: emulate validate_presence_of
  # these are dynamicly created attributes so they don't exist for the model
  validates_format_of :activity_score_name, :with => /^.+$/, :message => "ActivityScore Name can't be blank"
  validates_numericality_of :activity_score_value, :only_integer => true, :message => "ActivityScore Value must be an integer"
  validates_format_of :activity_score_value, :with => /^.+$/, :message => "ActivityScore Value can't be blank"
  validates_format_of :activity_score_sub_type_name, :with => /^[A-Za-z _]+$/, :message => "Title may only contain letters and spaces", :allow_blank => true

  def self.get name, sub_type = nil
    self.find_activity_score(name, sub_type)
  end
  
  def get_multiplier
    multiplier = Metadata::ActivityScore.find_activity_score(self.key_sub_type, 'importance')
    return (multiplier ? multiplier.value.to_i : 0)
  end
  
  def self.get_activity_score name, sub_type_name = nil
    self.find_activity_score(name, sub_type_name)
  end

  def self.find_activity_score name, key_sub_type = nil
    return self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, name]) if key_sub_type
    return self.find(:first, :conditions => ["key_name = ?", name])
  end

  def key() self.activity_score_name end

  def value
    self.activity_score_value
  end

  def score_type
    key_sub_type
  end  

  def score_value
    get_multiplier * value.to_i
  end  

  def enabled?
    !! self.value
  end

  def disabled?
    ! self.value
  end

  private

  def set_meta_keys
    self.meta_type    = 'activity_score'
    self.key_type     = 'app'
    self.key_sub_type ||= self.activity_score_sub_type_name
    self.key_name     ||= self.activity_score_name
  end

end
