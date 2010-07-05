class RelatedItemsController < ApplicationController

  def index
    @relatable = find_relatable
  end
  
  def new
    @relatable = find_relatable
    @related_item = RelatedItem.new
  end
    
  def create
    @relatable = find_relatable
    if @relatable.related_item params[:relatable_type],current_user
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
