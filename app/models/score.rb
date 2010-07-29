class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :scorable, :polymorphic => true

  named_scope :for_user, lambda { |*args| { :conditions => ["user_id = ?", args.first], :order => ["created_at desc"] } }


  def self.daily_scores limit = nil
    Rails.cache.fetch('daily_scores', :expires_in => 1.day, :force => self.force_fetch?) do
      self.calc_scores 1.day.ago, limit
    end
  end

  def self.weekly_scores limit = nil
    Rails.cache.fetch('weekly_scores', :expires_in => 1.day, :force => self.force_fetch?) do
      self.calc_scores 1.week.ago, limit
    end
  end

  def self.monthly_scores limit = nil
    Rails.cache.fetch('monthly_scores', :expires_in => 1.day, :force => self.force_fetch?) do
      self.calc_scores 1.month.ago, limit
    end
  end

  def self.yearly_scores limit = nil
    Rails.cache.fetch('yearly_scores', :expires_in => 1.day, :force => self.force_fetch?) do
      self.calc_scores 1.year.ago, limit
    end
  end

  def self.alltime_scores limit = nil
    Rails.cache.fetch('alltime_scores', :expires_in => 1.day, :force => self.force_fetch?) do
      self.calc_scores limit
    end
  end

  private

  def self.calc_scores time = nil, limit = 10
    limit ||= 10
    if time.nil?
    	self.find(:all, :select => "SUM(IF(score_type = 'karma', value, 0)) AS karma_score, SUM(IF(score_type = 'participation', value, 0)) AS activity_score, SUM(value) AS total_score, user_id", :conditions => ["user_id NOT IN (SELECT id FROM users WHERE is_admin is true or is_moderator is true)"], :group => "user_id", :having => "total_score > 0", :limit => limit, :include => :user, :order => "total_score desc")
    else
    	self.find(:all, :select => "SUM(IF(score_type = 'karma', value, 0)) AS karma_score, SUM(IF(score_type = 'participation', value, 0)) AS activity_score, SUM(value) AS total_score, user_id", :conditions => ["user_id NOT IN (SELECT id FROM users WHERE is_admin is true or is_moderator is true) AND created_at > ?", time], :having => "total_score > 0", :group => "user_id", :limit => limit, :include => :user, :order => "total_score desc")
    end
  end

  def self.force_fetch?
    @force ||= Rails.env.development?
  end

end
