class ScoreWorker
  @queue = :scores

  # Takes a Scorable Type, Scorable ID, and the User ID responsible
  def self.perform(scorable_type, scorable_id, user_id)
    scorable = scorable_type.constantize.find(scorable_id)
    user = User.active.find_by_id(user_id)
    if user
      score = scorable.add_score(user.id)
      user.add_score! score
    end
  end

end
