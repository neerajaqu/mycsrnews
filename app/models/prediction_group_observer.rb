class PredictionGroupObserver < ActiveRecord::Observer
  def after_create(prediction_group)
    Notifier.deliver_prediction_group_message(prediction_group)
  end
end
