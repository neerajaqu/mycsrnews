module QuestionsHelper

  def asked_by question
    I18n.translate('asked_by', :fb_name => local_linked_profile_name(question.user), :date => timeago(question.created_at)).html_safe
  end

  def answered_by answer
    I18n.translate('answered_by', :fb_name => local_linked_profile_name(answer.user), :date => timeago(answer.created_at)).html_safe
  end

end
