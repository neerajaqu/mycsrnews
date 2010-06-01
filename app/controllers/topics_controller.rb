class TopicsController < ApplicationController
  before_filter :find_forum
  before_filter :login_required, :only => [:new]

  def new
    @topic = @forum.topics.new
  end

  def show
    @topic = @forum.topics.find(params[:id])
    @topic.viewed!
  end

  def create
    success = false
    @topic = @forum.topics.build(params[:topic])

    @topic.transaction do
      @topic.user = current_user
      @post = @topic.posts.build({:comments => @topic.body, :user => current_user})
      @post.commentable = @topic
      success = @topic.save
    end

    if success
    	flash[:success] = "Successfully posted your new topic!"
    	redirect_to [@forum, @topic]
    else
    	render :new
    end
  end

  private

  def find_forum
    if params[:forum_id]
      @forum = Forum.find(params[:forum_id])
    elsif params[:id]
    	@topic = Topic.find(params[:id])
    	redirect_to forum_topic_path(@topic.forum, @topic)
    else
    	redirect_to forums_path
    end
  end

  def set_current_tab
    @current_tab = 'forums'
  end

end
