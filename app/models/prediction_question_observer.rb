class PredictionQuestionObserver < ActiveRecord::Observer
  def after_create(prediction_question)
    Notifier.deliver_prediction_question_message(prediction_question)
  end
end
