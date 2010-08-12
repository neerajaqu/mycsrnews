class PredictionSweeper < ActionController::Caching::Sweeper
  observe PredictionGroup, PredictionQuestion

  def after_save(record)
    if record.is_a?(PredictionGroup)
    	clear_group_cache(record)
    elsif record.is_a?(PredictionQuestion)
    	clear_question_cache(record)
    else
    	return false
    end
  end

  def after_destroy(record)
    if record.is_a?(PredictionGroup)
    	clear_group_cache(record)
    elsif record.is_a?(PredictionQuestion)
    	clear_question_cache(record)
    else
    	return false
    end
  end

  def clear_group_cache(prediction_group)
    ['top_prediction_groups', 'newest_prediction_groups', "#{prediction_group.cache_key}_top", "#{prediction_group.cache_key}_bottom", "#{prediction_group.cache_key}_who_liked" ].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "prediction_groups_#{page}html"
    end
  end

  def clear_question_cache(prediction_question)
    ['top_prediction_questions', 'newest_prediction_questions', "#{prediction_question.cache_key}_top", "#{prediction_question.cache_key}_bottom", "#{prediction_question.cache_key}_who_liked" ].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "prediction_questions_#{page}html"
    end
  end

  def self.expire_group_all prediction_group
    controller = ActionController::Base.new
    ['top_prediction_groups', 'newest_prediction_groups', "#{prediction_group.cache_key}_top", "#{prediction_group.cache_key}_bottom"].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "questions_list_#{page}html"
    end
  end

  def self.expire_question_all prediction_question
    controller = ActionController::Base.new
    ['top_prediction_questions', 'newest_prediction_questions', "#{prediction_question.cache_key}_top", "#{prediction_question.cache_key}_bottom"].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "questions_list_#{page}html"
    end
  end

  def self.expire_answer_all answer
    controller = ActionController::Base.new
    ['top_answers', 'newest_answers', 'unanswered_questions'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
      controller.expire_fragment "#{fragment}_fbml"
    end
    PredictionSweeper.expire_question_all answer.question
  end

end
