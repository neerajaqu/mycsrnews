module ForumsHelper
  def forum_breadcrumbs item
    breadcrumbs(item, link_to('Forums', forums_path))
  end

  def forum_posted_by_with_topic item
    case item.class
    when Topic.name
      I18n.translate('posted_by_in_topic', :fb_name => local_linked_profile_name(item.user), :topic => item.forum.item_title).html_safe
    when PredictionQuestion.name
      I18n.translate('posted_by_in_topic', :fb_name => local_linked_profile_name(item.user), :topic => item.prediction_group.item_title).html_safe
    else
      I18n.translate('posted_by', :fb_name => local_linked_profile_name(item.user), :date => timeago(item.created_at)).html_safe
    end
  end
end
