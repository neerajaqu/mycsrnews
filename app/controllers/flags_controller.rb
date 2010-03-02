class FlagsController < ApplicationController
  before_filter :login_required, :only => [:create]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def create
    @flaggable = find_moderatable_item
    if @flaggable.flag_item params[:flag_type]
    	# TODO:: change this to work with polymorphic associations, switch to using touch
    	#expire_page :controller => 'stories', :action => 'show', :id => @story
    	flash[:success] = "Thank you for flagging this item. We will investigate this shortly."
    	redirect_to @flaggable
    else
    	flash[:error] = "Could not flag this item."
    	redirect_to @flaggable
    end
  end

  def block
    @item = find_moderatable_item
    if @item.moderatable? and @item.blockable? and @item.toggle_blocked
      # todo - if block user, then use fb:ban api call too! or unban
    	flash[:success] = "Successfully #{@item.blocked? ? "Blocked" : "UnBlocked"} your item."
    	redirect_to @item
    else
    	flash[:error] = "Could not block this item."
    	redirect_to @item
    end
  end

  def feature
    @item = find_moderatable_item
    if @item.moderatable? and @item.featurable? and @item.toggle_featured
    	flash[:success] = "Successfully featured your item."
    	#redirect_to [:admin, :contents]
    	redirect_to @item
    else
    	flash[:error] = "Could not feature this item."
    	redirect_to @item
    end
  end

  private

  def find_moderatable_item
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
