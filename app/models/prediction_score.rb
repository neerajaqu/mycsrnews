class PredictionScore < ActiveRecord::Base
  acts_as_moderatable

  belongs_to  :user

  #todo - set guesscount to e.g. 5
  named_scope :top, lambda { |*args| { :conditions => ["guess_count > ?", 0], :order => ["accuracy desc"], :limit => (args.first || 5), :conditions => [" correct_count > 0"]} }

  def increment_score correct
    self.class.increment_counter :guess_count, self.id
    self.class.increment_counter :correct_count, self.id if correct
    self.reload
    self.update_attribute("accuracy", self.accuracy)
    #todo - send notification to guessers that question is complete  
  end
  
  def accuracy
    self.correct_count.to_f / self.guess_count.to_f
  end

  def refresh_all_scores
    # reset all scores
    PredictionScore.all.each do |prediction_score|
      guess_count = prediction_score.user.prediction_guesses.count
      correct_count = prediction_score.user.prediction_guesses.calculate(:count, :conditions => [ "is_correct = ?", true ])
      if guess_count > 0
        accuracy = correct_count.to_f / guess_count.to_f
      else
        accuracy = 0
      end
      prediction_score.update_attributes( { :guess_count => guess_count, :correct_count => correct_count, :accuracy => accuracy })
    end
  end
  
  def expire
    self.class.sweeper.expire_prediction_score_all self
  end

  def self.sweeper
    PredictionSweeper
  end

end
