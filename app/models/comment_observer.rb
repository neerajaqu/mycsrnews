class CommentObserver < ActiveRecord::Observer

  def after_create(comment)
    # Notify the poster of the original module item
    # Notify the last 3 commenters in the thread
    # Check user_profile settings with each before sending notification
  end
end
