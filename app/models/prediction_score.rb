class PredictionScore < ActiveRecord::Base
  acts_as_moderatable

  belongs_to  :user

  #todo - add minimum number of guesses to qualify
  named_scope :top, lambda { |*args| { :order => ["accuracy desc"], :limit => (args.first || 5), :conditions => [" correct_count > 0"]} }

  def increment_score correct
    self.class.increment_counter :guess_count, self.id
    self.class.increment_counter :correct_count, self.id if correct
    self.update_attribute("accuracy", self.accuracy)
  end
  
  def accuracy
    self.correct_count.to_f / self.guess_count.to_f
  end
  
  def expire
    self.class.sweeper.expire_prediction_score_all self
  end

  def self.sweeper
    PredictionSweeper
  end

end
