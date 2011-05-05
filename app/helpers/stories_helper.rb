module StoriesHelper

  def story_source_link(story)
    return link_to(URI.parse(story.url).host.gsub("www.",""), story.url)
  end
  
  def source_link(story)
    link_to story.source.name, "http://#{story.source.url}"
  end

  def stories_posted_by_via story
    I18n.translate('posted_by_via',
                   :fb_name => local_linked_profile_name(story.user),
                   :source => (story.source.present? ? story_source_link(story) : source_link(story)),
                   :date => timeago(story.created_at)
                  ).html_safe
  end
end
