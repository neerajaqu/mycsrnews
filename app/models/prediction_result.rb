class PredictionResult < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :prediction_question
  
  validates_presence_of :result
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true

  def expire
    self.class.sweeper.expire_prediction_result_all self
  end

  def self.sweeper
    PredictionSweeper
  end

end
