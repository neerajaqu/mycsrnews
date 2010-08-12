class QandaSweeper < ActionController::Caching::Sweeper
  observe Question, Answer

  def after_save(record)
    if record.is_a?(Question)
    	clear_question_cache(record)
    elsif record.is_a?(Answer)
    	clear_answer_cache(record)
    else
    	return false
    end
  end

  def after_destroy(record)
    if record.is_a?(Question)
    	clear_question_cache(record)
    elsif record.is_a?(Answer)
    	clear_answer_cache(record)
    else
    	return false
    end
  end

  def clear_question_cache(question)
    ['featured_questions','top_questions', 'newest_questions', 'unanswered_questions', "#{question.cache_key}_top", "#{question.cache_key}_bottom" , "#{question.cache_key}_who_liked" ].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "questions_list_#{page}html"
    end
  end

  def clear_answer_cache(answer)
    ['featured_answers','top_answers', 'newest_answers', 'unanswered_questions'].each do |fragment|
      expire_fragment "#{fragment}_html"
    end
    clear_question_cache answer.question
  end

  def self.expire_question_all question
    controller = ActionController::Base.new
    ['featured_questions','top_questions', 'newest_questions', 'unanswered_questions', "#{question.cache_key}_top", "#{question.cache_key}_bottom"].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      controller.expire_fragment "questions_list_#{page}html"
    end
  end

  def self.expire_answer_all answer
    controller = ActionController::Base.new
    ['featured_answers','top_answers', 'newest_answers', 'unanswered_questions'].each do |fragment|
      controller.expire_fragment "#{fragment}_html"
    end
    QandaSweeper.expire_question_all answer.question
  end

end
