class CommentsController < ApplicationController
  before_filter :login_required, :only => [:create,:like]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    @comment.comments = @template.sanitize_user_content @comment.comments
    if @comment.save
    	# TODO:: change this to work with polymorphic associations, switch to using touch
    	#expire_page :controller => 'stories', :action => 'show', :id => @story
    	redirect_to @commentable
    else
    	redirect_to @commentable
    end
  end

  def like
     @comment = Comment.find_by_id(params[:id])
     respond_to do |format|
       if current_user and @comment.present? and current_user.vote_for(@comment)
       	success = "Thanks for your vote!"
       	format.html { flash[:success] = success; redirect_to params[:return_to] || comments_path }
       	format.fbml { flash[:success] = success; redirect_to params[:return_to] || comments_path }
       	format.json { render :json => { :msg => "#{@comment.votes.size} likes" }.to_json }
       	format.fbjs { render :json => { :msg => "#{@comment.votes.size} likes" }.to_json }
       else
       	error = "Vote failed"
       	format.html { flash[:error] = error; redirect_to params[:return_to] || comments_path }
       	format.fbml { flash[:error] = error; redirect_to params[:return_to] || comments_path }
       	format.json { render :json => { :msg => error }.to_json }
       	format.fbjs { render :text => { :msg => error }.to_json }
       end
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
