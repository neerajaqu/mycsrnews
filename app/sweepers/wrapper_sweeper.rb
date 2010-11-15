class WrapperSweeper < ActionController::Caching::Sweeper

  def self.expire_item item
    case item.class.name
      when "Content"
        StorySweeper.expire_story_all item
      when "Article"
        StorySweeper.expire_story_all item.content
      when "Idea"
        IdeaSweeper.expire_idea_all item
      when "Question"
        QandaSweeper.expire_question_all item
      when "Answer"
        QandaSweeper.expire_answer_all item
      when "Resource"
        ResourceSweeper.expire_resource_all item
      when "Event"
        EventSweeper.expire_event_all item
      when "Prediction"
        PredictionSweeper.expire_prediction_all item
      else
      	nil
    end    
  end  

end
