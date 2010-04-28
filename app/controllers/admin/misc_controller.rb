class Admin::MiscController < AdminController

  def feature
    @item = find_moderatable_item

    if @item.moderatable? and @item.toggle_featured
    	expire_cache @item
    	flash[:success] = "Successfully #{@item.is_featured? ? 'featured' : 'unfeatured'} your item."
    	#redirect_to [:admin, :contents]
    	redirect_to [:admin, @item]
    else
    	flash[:error] = "Could not feature this item. #{@item.errors.full_messages.join '. '}"
    	redirect_to [:admin, @item]
    end
  end

  def block
    @item = find_moderatable_item

    if @item.moderatable? and @item.toggle_blocked
    	expire_cache @item
    	flash[:success] = "Successfully #{@item.is_blocked? ? 'blocked' : 'unblocked'} your item."
    	#redirect_to [:admin, :contents]
    	redirect_to [:admin, @item]
    else
    	flash[:error] = "Could not block this item. #{@item.errors.full_messages.join '. '}"
    	redirect_to [:admin, @item]
    end
  end

  def flag
    @item = find_moderatable_item

    # TODO:: change the flag type here to user selected
    if @item.moderatable? and @item.flag_item('other', current_user)
    	flash[:success] = "Successfully flagged your item."
    	#redirect_to [:admin, :contents]
    	redirect_to [:admin, @item]
    else
    	flash[:error] = "Could not flag this item."
    	redirect_to [:admin, @item]
    end
  end

end
