class ViewTree

  def initialize
    # Initialize new view tree
    # add children view tree elements for each view object
    # build up render dependency tree
    # add enumerable methods
  end

  def self.render target
    if target.class.name =~ /Controller$/
    	view_object_name = "#{target.controller_name}--#{target.action_name}"
    else
    	view_object_name = target
    end
    self.fetch view_object_name
  end

  def self.fetch key_name
    output = $redis.get(key_name)
    if output
    	return output
    else output
      output = ViewObject.load(key_name)
    end
    output
  end

end
