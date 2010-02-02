class Mobile::CommentsController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "mobile" }

  def show
    @comment = Comment.find(params[:id])
  end

end
