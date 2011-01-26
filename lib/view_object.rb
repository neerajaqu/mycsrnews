# Controller::
#    vo = ViewObject.new self
#    ['shared/stories', 'shared/sidebar/top_stories', 'shared/sidebar/top_discussed_stories', 'shared/sidebar/top_users'].each {|p| vo.push p}
#    vo.render
#    return true
# View:
#   - view_object.set('foo') { Content.top }
class ViewObject
  include Enumerable
  extend Forwardable

  def_delegators :@views, :<<, :[], :[]=, :last, :first, :push

  def initialize controller
    # TODO:: figure out how to make this work
    #@controller = controller ||= ActionController::Base.new
    @controller = controller
    @views = []
    @output = []
    @locals = {}
  end

  def each
    @views.each {|view| yield view }
  end

  def render
    each do |view|
      @output.push @controller.send(:render_to_string, :partial => view, :locals => { :view_object => self })
    end
    @controller.send(:render, :text => @output, :layout => 'application')
  end

  def set(key, val = nil, &block)
    raise ArgumentError.new("value or block must be provided") if val.nil? and not block_given?

    @locals[key] = block_given? ? yield : val
    raise @locals.inspect
  end

  def get(key)
    @locals[key]
  end

end
