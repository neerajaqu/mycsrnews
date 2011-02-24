module GenericItemHelper
  
  def render_generic_item item
    klass = item.class.name.underscore
    render :partial => "shared/items/#{klass}", :locals => { klass.to_sym => item }
  end

  def d2_render_generic_item item
    klass = item.class.name.underscore
    if klass == 'content' or klass == 'resource'
      render :partial => "shared/items/d2_#{klass}", :locals => { klass.to_sym => item }
    end
  end

  def render_generic_small_item item
    klass = item.class.name.underscore
    render :partial => "shared/items/small_#{klass}", :locals => { klass.to_sym => item }
  end

end
