class Admin::FeaturedItemsController < AdminController
  layout proc {|c| c.request.xhr? ? false : "new_admin" }
  before_filter :set_featured_types, :only => :load_template
  cache_sweeper :story_sweeper, :only => [:save]

  def index
  end

  def load_template
    return false unless params[:id] =~ /^template_[0-9]+$/

    @template_id = params[:id]
  end

  def load_items
    case params[:id]
      when Content.name.tableize
        @items = Content.active.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
      when Idea.name.tableize
        @items = Idea.active.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
      when Event.name.tableize
        @items = Event.active.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
      when Resource.name.tableize
        @items = Resource.active.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
      when Question.name.tableize
        @items = Question.active.paginate :page => params[:page], :per_page => 12, :order => "created_at desc"
      else
      	return false
    end
  end

  def save
    FeaturedItem.all.each {|fi| fi.destroy}

    data = ActiveSupport::JSON.decode(params['featured_items'])
    @template_name = FeaturedItem.create({:name => 'featured_template', :featured_type => data['template']})
    @section1 = @template_name.children.create({:name => "section1", :featured_type => "section1"})
    @section2 = @template_name.children.create({:name => "section2", :featured_type => "section2"})
    @section3 = @template_name.children.create({:name => "section3", :featured_type => "section3"})
    @section4 = @template_name.children.create({:name => "section4", :featured_type => "section4"})
    @section5 = @template_name.children.create({:name => "section5", :featured_type => "section5"})
    @section6 = @template_name.children.create({:name => "section6", :featured_type => "section6"})
    ['section1', 'section2','section3','section4','section5','section6'].each do |section|
      section_data = instance_variable_get("@#{section}")
      ['primary', 'secondary1', 'secondary2'].each do |box|
        item_id = data[section][box]
        next unless item = get_item(item_id)
        item = get_item item_id
        section_data.children.create({:name => "item_#{item_id}", :featured_type => "featured_item", :featurable => item})
        #@tweet_features = Metadata::Setting.find_setting('tweet_featured_items')
        #tweet(item) if (@tweet_features.present? and @tweet_features.value)
      end
    end

    WidgetSweeper.expire_all
    render :json => {:success => "Success!"}.to_json and return
  end

  private

  def get_item item
    return false unless item and item =~ /^([^_]+)_([0-9]+)$/
    case $1
      when 'content'
        return Content.find_by_id($2)
      when 'idea'
        return Idea.find_by_id($2)
      when 'event'
        return Event.find_by_id($2)
      when 'resource'
        return Resource.find_by_id($2)
      when 'question'
        return Question.find_by_id($2)
      else
      	return false
    end
  end

  def set_featured_types
    @featurables ||= [['Stories', 'contents'], ['Ideas', 'ideas'], ['Questions', 'questions'], ['Resources', 'resources'], ['Events', 'events']]
  end

  def set_current_tab
    @current_tab = 'featured-items';
  end

  def tweet item
    return if item.tweeted_item.present?
    
    if Metadata::Setting.find_setting('bitly_username').value
      bitly = Bitly.new(Metadata::Setting.find_setting('bitly_username').value, Metadata::Setting.find_setting('bitly_api_key').value)
      shrt = bitly.shorten(url)
      return shrt.short_url
    else
      return url
    end
    
    oauth = Twitter::OAuth.new(Metadata::Setting.find_setting('oauth_key').value, Metadata::Setting.find_setting('oauth_secret').value)
    oauth.authorize_from_access(Metadata::Setting.find_setting('twitter_oauth_consumer_key').value, Metadata::Setting.find_setting('twitter_oauth_consumer_secret').value)
    twitter = Twitter::Base.new(oauth)
    
    case item.class.name
    when "Content"
      msg = "#{item.title} #{shorten_url(story_url(item))}"
    when "Question"
      msg = "#{item.question} #{shorten_url(question_url(item))}"
    when "Idea"
      msg = "#{item.title} #{shorten_url(idea_url(item))}"
    when "Event"
      msg = "#{item.name} #{shorten_url(event_url(item))}"
    end

    twitter.update(msg)
    item.create_tweeted_item
  end
end
