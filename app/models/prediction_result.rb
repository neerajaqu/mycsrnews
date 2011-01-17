class PredictionResult < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :accepted_by, :class_name => 'User', :foreign_key => :accepted_by_user_id
  belongs_to  :prediction_question
  
  named_scope :correct, :conditions => { :is_accepted => true }
  validates_presence_of :result
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => true
  validate :valid_result

  def valid_result
    unless result == 'incorrect' or prediction_question.valid_guess? result
      errors.add(:result, "Incorrect result, please try again.")
    end
    if result == 'incorrect' and not alternate_result.present?
    	errors.add(:alternate_result, "Please provide an alternate result to none of the above.")
    end
  end

  def expire
    self.class.sweeper.expire_prediction_result_all self
  end

  def self.sweeper
    PredictionSweeper
  end

  def answer
    result == 'incorrect' ? alternate_result : result
  end

  def accept! user
    self.is_accepted = true
    self.accepted_at = Time.zone.now.to_datetime
    self.accepted_by = user
    if self.save
    	prediction_question.accept_prediction_result self
    else
    	return false
    end
  end

end
