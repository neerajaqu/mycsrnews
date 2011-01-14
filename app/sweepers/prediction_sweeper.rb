class PredictionSweeper < ActionController::Caching::Sweeper
  observe PredictionGroup, PredictionQuestion, PredictionGuess, PredictionResult, PredictionScore

  def after_save(record)
    if record.is_a?(PredictionGroup)
      PredictionSweeper.expire_prediction_group_all(record)
    elsif record.is_a?(PredictionQuestion)
      PredictionSweeper.expire_prediction_question_all(record)
    elsif record.is_a?(PredictionGuess)
      PredictionSweeper.expire_prediction_guess_all(record)
    elsif record.is_a?(PredictionResult)
      PredictionSweeper.expire_prediction_result_all(record)
    elsif record.is_a?(PredictionScore)
      PredictionSweeper.expire_prediction_score_all(record)
    end
  end

  def after_destroy(record)
    if record.is_a?(PredictionGroup)
      PredictionSweeper.expire_prediction_group_all(record)
    elsif record.is_a?(PredictionQuestion)
      PredictionSweeper.expire_prediction_question_all(record)
    elsif record.is_a?(PredictionGuess)
      PredictionSweeper.expire_prediction_guess_all(record)
    elsif record.is_a?(PredictionResult)
      PredictionSweeper.expire_prediction_result_all(record)
    elsif record.is_a?(PredictionScore)
      PredictionSweeper.expire_prediction_score_all(record)
    end
  end

  def self.expire_static
    controller = ActionController::Base.new
    controller.expire_fragment 'suggest_prediction'
  end
  
  def self.expire_prediction_group_all prediction_group
    controller = ActionController::Base.new
    ['suggest_prediction','newest_prediction_groups', 'top_prediction_groups', "#{prediction_group.cache_key}_group_list"].each do |fragment|
      controller.expire_fragment fragment
    end
  end

  def self.expire_prediction_question_all prediction_question
    controller = ActionController::Base.new
    ["closed_predictions","top_predictions","newest_predictions","#{prediction_question.cache_key}_stats_html"].each do |fragment|
      controller.expire_fragment fragment
    end

    PredictionSweeper.expire_prediction_group_all prediction_question.prediction_group
  end

  def self.expire_prediction_guess_all prediction_guess
    controller = ActionController::Base.new
    #["#{prediction_guess.cache_key}_voices"].each do |fragment|
    #  controller.expire_fragment fragment
    #end

    PredictionSweeper.expire_prediction_question_all prediction_guess.prediction_question
  end

  def self.expire_prediction_result_all prediction_result
    controller = ActionController::Base.new
    ["#{prediction_result.cache_key}_voices","prediction_high_scores_html"].each do |fragment|
      controller.expire_fragment fragment
    end
    ['', 'page_1_', 'page_2_'].each do |page|
      expire_fragment "prediction_scores_list_#{page}html"
    end
    PredictionSweeper.expire_prediction_question_all prediction_result.prediction_question
  end

  def self.expire_prediction_score_all prediction_score
    controller = ActionController::Base.new
    ["#{prediction_score.cache_key}_voices"].each do |fragment|
      controller.expire_fragment fragment
    end
  end

end
