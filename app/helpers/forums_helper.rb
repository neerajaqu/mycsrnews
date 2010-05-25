module ForumsHelper
  def forum_breadcrumbs item
    breadcrumbs item, link_to('Forums', forums_path)
  end
end
