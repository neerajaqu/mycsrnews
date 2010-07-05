module StoriesHelper

  def story_source_link(story)
    return link_to(URI.parse(story.url).host.gsub("www.",""), story.url)
  end
  
  def source_link(story)
    link_to story.source.name, "http://#{story.source.url}"
  end
end
