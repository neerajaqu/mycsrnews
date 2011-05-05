module LocalesHelper

  def generic_posted_by item
    I18n.translate('posted_by', :fb_name => local_linked_profile_name(item.user), :date => timeago(item.created_at)).html_safe
  end
  alias_method :stories_posted_by, :generic_posted_by

end
