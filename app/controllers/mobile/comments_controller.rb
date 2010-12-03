class Mobile::CommentsController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "mobile" }

  def show
    @comment = Comment.active.find(params[:id])
  end

end
