class VoteSweeper < ActionController::Caching::Sweeper
  observe Vote

  def after_save(vote)
    if vote.voteable.is_a?(Content)
    	story = vote.voteable
    elsif vote.voteable.is_a?(Comment) and vote.voteable.commentable.is_a?(Content)
      story = vote.voteable.commentable
    else
    	story = false
    end

    StorySweeper.expire_story_all story if story
  end

end
