class Article < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable
  acts_as_relatable

  has_one :content
  has_one :tweeted_item, :as => :item
  belongs_to :author, :class_name => "User"

  named_scope :published, { :conditions => ["is_draft = 0"] }
  named_scope :draft, { :conditions => ["is_draft = 1"] }
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["featured_at desc"], :limit => (args.first || 1)} }
  named_scope :blog_roll, lambda { |*args| {  :select => "count(author_id) as author_article_count, author_id", :group => "author_id", :order => "author_article_count desc", :limit => (args.first || 30)} }

  accepts_nested_attributes_for :content

  validates_presence_of :body
  
  #todo - was removing formatting from drafts - not sure of purpose
  #before_save :sanitize_body

  def item_title
    content.item_title
  end

  def item_description
    content.item_description
  end

  def item_link
    content
  end

  def toggle_blocked
    self.content.toggle_blocked
  end

  def create_preamble
    t1 = self.body.gsub("<br><br><br><br>","<br /><br />").gsub("&nbsp;"," ").gsub("\r\n","<br /><br />").gsub("\r", "").gsub("\n", "<br />")
    t2 = ActionController::Base.helpers.sanitize(t1, :tags => %w(br))
    t3 = t2.split(/(?:<br>)+/)
    full_entry = (t3.count > 3 ? false : true)
    preamble = ""
    index = 0
    t3.each do |graf|
      unless index >= 3 or preamble.length > 500
        if graf.length > 497
          graf = graf[/^.{0,497}(?=\w*\;?)/m][/.*[\w\;]/m] + "..."
          full_entry = false
        end
        preamble += "<p>" + graf + "</p>"
        index +=1
      end
    end
    self.preamble_complete = full_entry
    self.preamble = preamble
  end
      
  private  
  
  def sanitize_body
    self.body = self.body.sanitize_standard
  end
end
