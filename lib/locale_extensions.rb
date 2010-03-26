class Translation

  named_scope :with_type, lambda { |type|
    return {} if type.nil?
    { :conditions => ["raw_key LIKE ?", "#{type}%"] }
  }

end