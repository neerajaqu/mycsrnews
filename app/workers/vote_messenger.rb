class VoteMessenger
  @queue = :vote_messenger

  def self.perform(vote_id, item_url, image_url)
    vote = Vote.find(vote_id)

    self.facebook_messenger vote, item_url, image_url
  end

  def self.facebook_messenger vote, item_url, image_url
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
    fb_client.post("#{vote.voter.fb_user_id}/feed", "Post", :message => "likes", :link => item_url, :name => vote.voteable.item_title, :caption => caption, :picture => image_url)
  end
    
end