class CommentsController < ApplicationController
  before_filter :login_required, :only => [:create]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
    	# TODO:: change this to work with polymorphic associations, switch to using touch
    	#expire_page :controller => 'stories', :action => 'show', :id => @story
    	redirect_to @commentable
    else
    	redirect_to @commentable
    end
  end

  private

  def find_commentable
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
