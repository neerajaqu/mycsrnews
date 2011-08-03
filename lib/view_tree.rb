class ViewTree
  include Enumerable
  extend Forwardable

  def_delegators :@children, :<<, :[], :[]=, :last, :first, :push

  def initialize key_name, controller = nil, view_object = nil
    @key_name = key_name
    @cache_key_name = self.class.view_tree_cache_key_name @key_name
    @view_object = view_object
    @children = []
    @controller = controller
    #@cache = true
    @cache = Rails.env.production? and not key_name =~ /--/ and key_name != 'Welcome Panel'
    # Initialize new view tree
    # add children view tree elements for each view object
    # build up render dependency tree
    # add enumerable methods
  end

  def each
    @children.each {|child| yield child }
  end
  
  def cache_it output
    if @cache and @view_object
      @view_object.cache_deps
      $redis.set("#{@cache_key_name}", output)
    end
    output
  end

  def uncache_it
    if @cache and @view_object
      @view_object.uncache_deps
      $redis.del("#{@cache_key_name}", @output)
    end
  end

  def translate locale_key, options = {}
    I18n.translate(locale_key, options)
  end
  alias_method :t, :translate

  def load_view_object
    @view_object = ViewObject.load(@key_name)
    @children = @view_object.edge_children.map {|c| ViewTree.new c.name, @controller }
    @view_object
  end

  def load
    output = []
    unless @view_object.parent.nil? and @view_object.view_object_template.nil?
      output << render_string
    end
    each do |child|
      output << child.render
    end

    return output.flatten.join('')
  end

  def render_string
    return %{<div class="box">#{@controller.send(:render_to_string, :partial => "#{@view_object.view_object_template.template}.html", :locals => { :vt => self, :vo => @view_object })}</div>}
  end

  def render
    if @cache and out = $redis.get(@cache_key_name) and out.present?
      return out
    else
      load_view_object
      return '' unless @view_object
      uncache_it
    end

    return cache_it self.load
  end

	#
	# Class Methods
	#
  def self.render target, controller = nil
    if target.class.name =~ /Controller$/
    	view_object_name = "#{target.controller_name}--#{target.action_name}"
    	controller = target
    else
    	view_object_name = target
    end
    self.fetch view_object_name, controller
  end

  def self.fetch key_name, controller
    view_tree = ViewTree.new key_name, controller
    return view_tree.render
  end

  def self.cache_key_name key_name
    key_name.parameterize.to_s
  end

  def self.view_tree_cache_key_name key_name
    "view-tree:#{self.cache_key_name(key_name)}"
  end

end
