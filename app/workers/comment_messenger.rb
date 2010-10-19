class CommentMessenger
  @queue = :comment_messenger

  def self.perform(comment_id, item_url, app_caption, image_url)
    comment = Comment.find(comment_id)

    self.facebook_messenger comment, item_url, app_caption, image_url
  end

  def self.facebook_messenger comment, item_url, app_caption, image_url
    fb_client = Mogli::Client.new comment.user.fb_oauth_key
    begin
      caption = ActionController::Base.helpers.strip_tags(comment.comments)
    rescue
      begin
        caption = HTML::FullSanitizer.new.sanitize(comment.comments)
      rescue
        caption = comment.comments
      end
    end
    caption = caption[0,250]
    begin
      fb_client.post("#{comment.user.fb_user_id}/feed", "Post", :message => "commented on", :link => item_url, :name => comment.commentable.item_title, :caption => app_caption, :description => caption, :picture => image_url)
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