class DashboardMessage < ActiveRecord::Base

  belongs_to :user

  named_scope :sent, {:conditions => ["status = ?", 'sent'] }
  named_scope :unsent, {:conditions => ["status = ?", 'unsent'] }

  validates_length_of   :message,    :within => 3..50
  validates_length_of   :action_text,    :within => 3..25
  validates_format_of :action_url, :with => /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
  
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 1)} }

  def sent?
    self.status == 'sent'
  end

  def build_news
    [
      {
        :message => self.message,
        :action_link => {
          :text => self.action_text,
          :href => self.action_url
        }
      }
    ]
  end

  def set_draft! news_id
    self.news_id = news_id
    self.status = 'draft'
    save
  end

  def set_success! news_id
    self.news_id = news_id
    self.status = 'sent'
    save
  end

  def recipient_voices
    User.all
  end  

end
