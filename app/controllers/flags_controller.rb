class FlagsController < ApplicationController
  before_filter :login_required, :only => [:create]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def create
    @flaggable = find_flaggable
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

  private

  def find_flaggable
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
