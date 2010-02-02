class VoteObserver < ActiveRecord::Observer

  # TODO:: figure out why this triggers a bunch of times
  #def after_create(vote)
    #vote.update_user_karma
    #user = vote.voteable.user
    #vote_value = vote.vote ? 1 : -1
    #user.karma_score += vote_value
    #user.save
  #end
end
