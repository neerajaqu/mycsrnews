atom_feed do |feed|
  feed.title(APP_CONFIG['site_title'])
  feed.updated(@contents.first.created_at)

  @contents.each do |story|
    feed.entry(story, :url => story_url(story)) do |entry|
      entry.title(story.title)
      entry.content(story.caption, :type => 'html', :url => story_url(story))
      entry.author { |author| author.name(story.user.name) }
    end
  end
end
