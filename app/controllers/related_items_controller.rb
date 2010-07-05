class RelatedItemsController < ApplicationController
  before_filter :login_required, :only => [:create]

  def new
    @related_item = RelatedItem.new
  end
    
  def create
    @relatable = find_relatable
    @related_item = @relatable.related_items.build(params[:related_item])
    @related_item.user = current_user
    if @related_item.save
    	flash[:success] = "Thank you for creating this related item."
    	redirect_to @relatable
    else
    	flash[:error] = "Could not add this related item."
    	redirect_to @relatable
    end
  end

  private
  
  def find_relatable
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
