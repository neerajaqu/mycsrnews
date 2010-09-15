class CommentsController < ApplicationController
  before_filter :login_required, :only => [:create,:like]
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    @comment.comments = @template.sanitize_user_content @comment.comments
    if @comment.save
      # to do doesn't work for topic replies
      if @comment.post_wall?
        session[:post_wall] = @comment
      end
      if @comment.user.post_comments?
        image_url = (@comment.commentable.respond_to?(:images) and @comment.commentable.images.any?) ? @template.base_url(@comment.commentable.images.first.url(:thumb)) : nil
        app_caption = t('app.facebook.comment_caption', :title => APP_CONFIG['site_title'])
        @comment.async_comment_messenger polymorphic_path(@commentable.item_link, :only_path => false, :canvas => iframe_facebook_request?, :format => 'html'), app_caption, image_url
      end
    	# TODO:: change this to work with polymorphic associations, switch to using touch
    	#expire_page :controller => 'stories', :action => 'show', :id => @story
    	respond_to do |format|
    	  format.html { redirect_to @commentable }
    	  format.json { render(:partial => 'shared/comments.html', :locals => { :comments => @commentable.comments }) and return }
    	  #format.json { @comments = @commentable.comments }
    	end
    else
    	redirect_to @commentable
    end
  end

  def like
     @comment = Comment.find_by_id(params[:id])
     respond_to do |format|
       if current_user and @comment.present? and current_user.vote_for(@comment)
       	success = "Thanks for your vote!"
       	format.html { flash[:success] = success; redirect_to params[:return_to] || @comment.commentable }
       	format.fbml { flash[:success] = success; redirect_to params[:return_to] || @comment.commentable }
       	format.json { render :json => { :msg => "#{@comment.votes_tally}" }.to_json }
       	format.fbjs { render :json => { :msg => "#{@comment.votes_tally}" }.to_json }
       else
       	error = "Vote failed"
       	format.html { flash[:error] = error; redirect_to params[:return_to] || @comment.commentable }
       	format.fbml { flash[:error] = error; redirect_to params[:return_to] || @comment.commentable }
       	format.json { render :json => { :msg => error }.to_json }
       	format.fbjs { render :text => { :msg => error }.to_json }
       end
     end
   end

  def dislike
     @comment = Comment.find_by_id(params[:id])
     respond_to do |format|
       if current_user and @comment.present? and current_user.vote_against(@comment)
       	success = "Thanks for your vote!"
       	format.html { flash[:success] = success; redirect_to params[:return_to] || @comment.commentable }
       	format.fbml { flash[:success] = success; redirect_to params[:return_to] || @comment.commentable }
       	format.json { render :json => { :msg => "#{@comment.votes_tally}" }.to_json }
       	format.fbjs { render :json => { :msg => "#{@comment.votes_tally}" }.to_json }
       else
       	error = "Vote failed"
       	format.html { flash[:error] = error; redirect_to params[:return_to] || @comment.commentable }
       	format.fbml { flash[:error] = error; redirect_to params[:return_to] || @comment.commentable }
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
