class VoteMessenger
  @queue = :vote_messenger

  def self.perform(vote_id, item_url, app_caption, image_url)
    vote = Vote.find(vote_id)

    self.facebook_messenger vote, item_url, app_caption, image_url
  end

  def self.facebook_messenger vote, item_url, app_caption, image_url
    fb_client = Mogli::Client.new vote.voter.fb_oauth_key
    begin
      caption = ActionController::Base.helpers.strip_tags(vote.voteable.item_description)
    rescue
      begin
        caption = HTML::FullSanitizer.new.sanitize(vote.voteable.item_description)
      rescue
        caption = vote.voteable.item_description
      end
    end
    caption = caption[0,250]
    begin
      fb_client.post("#{vote.voter.fb_user_id}/feed", "Post", :message => "likes", :link => item_url, :name => vote.voteable.item_title, :caption => app_caption, :description => caption, :picture => image_url)
    rescue Exception => exception
      type, error = exception.to_s.split(':').map {|e| e.strip}
      if type == "OAuthException" and error =~ /^Error (processing|validating) access token/
        Rails.logger.error "***FB OAUTH ERROR*** #{exception.inspect}"
        vote.voter.update_attribute(:fb_oauth_key, nil)
      else
        Rails.logger.error "***FB MISC ERROR*** #{exception.inspect}"
      end
      raise Exception.new("FB GRAPH API EXCEPTION: #{exception.inspect}")
    end
  end
    
end