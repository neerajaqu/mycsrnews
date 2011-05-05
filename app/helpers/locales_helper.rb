module LocalesHelper

  def generic_posted_by item, user = nil
    user ||= item.user
    I18n.translate('posted_by', :fb_name => local_linked_profile_name(user), :date => timeago(item.created_at)).html_safe
  end
  alias_method :stories_posted_by, :generic_posted_by
  

  def user_posted_item item, user = nil
    user ||= item.user
    I18n.translate('user_posted_item', :fb_name => local_linked_profile_name(user, :only_path => false, :format => 'html'), :title => link_to(item.item_title, polymorphic_url(item.item_link,:only_path => false) ), :date => timeago(item.created_at)).html_safe
  end

end
