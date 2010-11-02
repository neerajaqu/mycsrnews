class VoteSweeper < ActionController::Caching::Sweeper
  observe Vote

  def after_save(vote)
    if vote.voteable.is_a?(Content)
      StorySweeper.expire_story_all vote.voteable
    elsif vote.voteable.is_a?(Article)
      StorySweeper.expire_article_all vote.voteable
    elsif vote.voteable.is_a?(Comment) and vote.voteable.commentable.is_a?(Content)
      StorySweeper.expire_story_all vote.voteable.commentable
    elsif vote.voteable.is_a?(Question)
      QandaSweeper.expire_question_all vote.voteable
    elsif vote.voteable.is_a?(Answer)
      QandaSweeper.expire_answer_all vote.voteable
    elsif vote.voteable.is_a?(Idea)
      IdeaSweeper.expire_idea_all vote.voteable
    elsif vote.voteable.is_a?(Event)
      EventSweeper.expire_event_all vote.voteable
    elsif vote.voteable.is_a?(Resource)
      ResourceSweeper.expire_resource_all vote.voteable
    elsif vote.voteable.is_a?(Topic)
      ForumSweeper.expire_topic_all vote.voteable
    elsif vote.voteable.is_a?(PredictionGroup)
      PredictionSweeper.expire_group_all vote.voteable
    elsif vote.voteable.is_a?(PredictionQuestion)
      PredictionSweeper.expire_question_all vote.voteable
    end
  end

end
