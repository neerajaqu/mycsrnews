class RelatedItemsController < ApplicationController
  before_filter :login_required, :only => [:create]
  before_filter :moderator_required, :only => [:create]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def new
    @relatable = find_relatable_item
    @related_item = RelatedItem.new
  end
  
  def moderator_required
    return true unless (@current_user.is_moderator or @current_user.is_host)
    @relatable = find_relatable_item
  	redirect_to @relatable
    return false
  end
    
  def create
    @relatable = find_relatable_item
    @related_item = @relatable.related_items.build(params[:related_item])
    @related_item.user = current_user
    if @related_item.save
    	expire_cache @relatable
    	flash[:success] = "Thank you for creating this related item."
    	redirect_to @relatable
    else
    	flash[:error] = "Could not add this related item."
    	redirect_to @relatable
    end
  end

  private
  
  def find_relatable_item
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

end
