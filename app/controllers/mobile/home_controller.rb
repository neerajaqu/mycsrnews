class Mobile::HomeController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "mobile" }

  def index
    @stories = Content.active.find(:all, :limit => 10, :order => "created_at desc")
    @top_stories = Content.active.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
    @comments = Comment.newest(10)
    @likes = Vote.newest(10)
  end

end
